#usersテーブル(ユーザーID, 氏名, パスワード)とbelongsテーブル(ユーザーID, そのユーザーのマネージャーのユーザーID, 部署ID)は手動で登録する(新入社員の追加など)ことを前提とする

class UsersController < ApplicationController
    
    protect_from_forgery

    def onGetLogin
   
        if Redis.current.get("user_data") == nil
            render "login"
        else
            redirect_to controller: "users", action: "onGetPeriod"
        end

    end

    def onPostLogin

        user_data = User.getItem(params[:user_id], params[:password])[0]

        if user_data == nil
            @message = "ユーザーIDかパスワードが間違っています"
            render "login"
        else
            Redis.current.set("user_data", user_data.to_json) 
            redirect_to controller: "users", action: "onGetPeriod"
        end

    end

    def onPostLogout

        Redis.current.del("user_data") 
        redirect_to controller: "users", action: "onGetLogin"

    end

    def onGetPeriod

        user_data = JSON.parse(Redis.current.get("user_data"))
        @user_name = user_data["user_name"]
        @user_id = user_data["user_id"]

        values = Department.getItem_withOtherTables(@user_id)[0]

        if user_data["department_name"] == nil
            user_data["department_name"] = values["department_name"]
            #セッションを更新
            Redis.current.set("user_data", user_data.to_json)
        end
        
        @department_name = user_data["department_name"]
        
        if @user_id == values["manager_user_id"]
            @path = "/users"
        else
            @path = "/report"
        end

        @period_array = []
        today = Date.today

        for i in 0..12 do
            date = today << i
            year = date.year.to_s
            month = date.month.to_s
            @period_array.push([year + "年" + month + "日", year + "-" + month])
        end

        render "period"

    end

    def onGetUsers
        
        user_data = JSON.parse(Redis.current.get("user_data"))
        
        @user_name = user_data["user_name"]
        @user_id = user_data["user_id"]
        @department_name = user_data["department_name"]
        @period = params[:period]

        @page_index = params[:page]

        if @page_index == nil
            @page_index = 1
        else
            @page_index = @page_index.to_i
        end
 
        '''テスト用にユーザーを大量追加
        users_data_array = []
        belongs_data_array = []
        states_data_array = []
    
        (10..99).each do |num|
          new_user_id = "H1841000" + num.to_s
          users_data_array.push({id: new_user_id, name: "テストユーザー" + num.to_s, password: "aiueo"})
          belongs_data_array.push({user_id: new_user_id, manager_user_id: @user_id, department_id: "A101"})
          states_data_array.push({user_id: new_user_id, period: @period, state: "編集中"})
        end
        
        User.import(users_data_array)
        Belong.import(belongs_data_array)
        State.import(states_data_array)
        '''

        @users = User.getItems_withOhterTables(@user_id, @period, @page_index)

        render "users"

    end

end
