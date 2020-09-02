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
        
        session[:user_data] = "まんち"
        user_data = session[:user_data]
        @user_name = user_data
        #@department_name = user_data["department_name"]
        #@maneger_flag = user_data["user_id"] == user_data["manager_user_id"]
        @maneger_flag = true
        #@department_name = user_data[4] #session[:department_name]
        
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

        @date = params[:date]
        @user_id = params[:user_data]
        @users = User.getNormalUsersData("H184100001", @date)
        
        render "users"

    end

end
