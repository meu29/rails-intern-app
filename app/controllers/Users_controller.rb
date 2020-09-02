#データベース.テーブル => sample_development.Users
require("date")

class UsersController < ApplicationController

    protect_from_forgery 

    def openLoginScreen
        render "login"
    end

    def login

        user_data = User.getUserData(params[:user_id], params[:password])

        if user_data == nil
            @message = "ユーザーIDかパスワードが間違っています"
            render "login"
        else
            session[:user_data] = user_data
            redirect_to "/selectPeriod"
        end 
    
    end

    def openSelectPeriodScreen
        
        #ページ遷移時にセッションが消える 
        session[:user_data] = User.getUserData("H184100001", "dvbs72bk")
        user_data = session[:user_data]
        @user_name = user_data["user_name"]
        @department_name = user_data["department_name"]
        @maneger_flag = user_data["user_id"] == user_data["manager_user_id"]

        @date_array = []
        today = Date.today

        for i in 0..12 do
            date = today << i
            year = date.year.to_s
            month = date.month.to_s
            if month.length == 1
              month = "0" + month
            end
            @date_array.push([year + "年" + month + "日", year + "-" + month])
        end

        render "selectPeriod"

    end
    '''
    def getReports
        @tweet = Users.new
        render template: "new/index"
        #render html: params[:user_name]
    end
    '''

    def getUsers

        @user_id = params[:user_data]
        @date = params[:date]
        @users = User.getNormalUsersData("H184100001", @date)
        
        render "users"

    end

end
