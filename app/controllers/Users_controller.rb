#データベース.テーブル => sample_development.Users
require("date")

class UsersController < ApplicationController

    protect_from_forgery

    def openLoginScreen

        if session[:user_data] == nil
            render "login"
        else
            redirect_to controller: "users", action: "openSelectPeriodScreen"
        end

    end

    def login

        user_data = User.getUserData(params[:user_id], params[:password])

        if user_data == nil
            @message = "ユーザーIDかパスワードが間違っています"
            render "login"
        else
            #セッションの保存はリダイレクト先でないとできない
            #redirect_to controller: "sessions", action: "createSessions", user_data: user_data
            redirect_to controller: "users", action: "openSelectPeriodScreen", user_data: user_data
        end 
    
    end

    def logout 

        redirect_to controller: "sessions", action: "deleteSessions"

    end

    def openSelectPeriodScreen
        
        if session["user_data"] == nil
          session[:user_data] = params[:user_data]
        end

        @user_id = session[:user_data]["user_id"]
        @user_name = session[:user_data]["user_name"]
        @department_name = session[:user_data]["department_name"]
        @maneger_flag = session[:user_data]["user_id"] == session[:user_data]["manager_user_id"]

        @period_array = []
        today = Date.today

        for i in 0..12 do
            date = today << i
            year = date.year.to_s
            month = date.month.to_s
            @period_array.push([year + "年" + month + "日", year + "-" + month])
        end

        render "selectPeriod"

    end

    def getUsers

        @period = params[:period]
        @users = User.getNormalUsersData(session[:user_data]["user_id"], @period)
        
        render "users"

    end

end
