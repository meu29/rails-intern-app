#usersテーブル(ユーザーID, 氏名, パスワード)とbelongsテーブル(ユーザーID, そのユーザーのマネージャーのユーザーID, 部署ID)は手動で登録する(新入社員の追加など)ことを前提とする

class UsersController < ApplicationController
    
    protect_from_forgery

    def onGetLogin
   
        if Redis.current.get("user_data") == nil
            render "login"
        else
            return redirect_to controller: "users", action: "onGetPeriod"
        end

    end

    def onPostLogin

        user_data = User.getItem(params[:user_id], params[:password])[0]

        if user_data == nil
            @message = "ユーザーIDかパスワードが間違っています"
            render "login"
        elsif user_data["user_name"] == "admin"
            Redis.current.set("user_data", user_data.to_json)
            redirect_to controller: "users", action: "onGetAdministrator_only"
        else
            Redis.current.set("user_data", user_data.to_json) 
            return redirect_to controller: "users", action: "onGetPeriod"
        end

    end

    def onGetLogout 
        Redis.current.del("user_data")
        return redirect_to controller: "users", action: "onGetLogin"
    end

    def onGetPeriod

        user_data = Redis.current.get("user_data")

        if user_data == nil 
            return redirect_to controller: "users", action: "onGetLogin"
        end

        user_data = JSON.parse(user_data)
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

    '''
    def onPostChangePassword

        user_data = Redis.current.get("user_data")

        if user_data == nil 
            return redirect_to controller: "users", action: "onGetLogin"
        end

        user_data = JSON.parse(user_data)
        User.updateItem(params[:user_id], params[:new_password])

        return redirect_to controller: "users", action: "onGetPeriod"

    end
    '''

    def onGetUsers
        
        user_data = Redis.current.get("user_data")

        if user_data == nil 
            return redirect_to controller: "users", action: "onGetLogin"
        end

        user_data = JSON.parse(user_data)
        
        @user_name = user_data["user_name"]
        @user_id = user_data["user_id"]
        @department_name = user_data["department_name"]
        @period = params[:period]
        @state = params[:state]
        @page_index = params[:page]

        if @page_index == nil
            @page_index = 1
        else
            @page_index = @page_index.to_i
        end

        @users = User.getItems_withOhterTables(@user_id, @period, @state, @page_index)

        render "users"

    end

    def onGetInvite

        user_data = Redis.current.get("user_data")

        if user_data == nil 
            return redirect_to controller: "users", action: "onGetLogin"
        end

        user_data = JSON.parse(user_data)

        @user_name = user_data["user_name"]
        @department_name = user_data["department_name"]

        render "invite"

    end

    def onPostInvite

    end

    #fetch専用'
    '''
    def onGetIndependentUsers
        render :json {"users"=>User.getItem_withBelongTable()}
    end
    '''

    def onGetAdministrator_only

        user_data = Redis.current.get("user_data")

        if user_data == nil 
            return redirect_to controller: "users", action: "onGetLogin"
        elsif JSON.parse(user_data)["user_name"] != "admin"
            redirect_to controller: "users", action: "onGetPeriod"
        end

        departments = Department.getItems()
        
        (0..departments.size - 1).each do |i|
            department = departments[i]
            departments[i] = [department["name"], department["id"]]
        end

        @departments = departments

        render "administrator_only"

    end

    def onPostCreateUser

        department_id = params[:department_id]
        values = Belong.getItem(department_id)

        latest_user_id = values[values.size - 1]["user_id"]
        user_id = latest_user_id[1..latest_user_id.size].to_i + 1
        user_id = latest_user_id[0] + user_id.to_s

        User.createItem(user_id, params[:user_name])
        Belong.createItem(user_id, values[values.size - 1]["manager_user_id"], department_id)
        
        redirect_to controller: "users", action: "onGetAdministrator_only"

    end

end
