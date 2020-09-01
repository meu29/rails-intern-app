#require("/home/meu/ドキュメント/RailsInternApp/app/models/user.rb")
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
            session[:user_id] = user_data[0]
            session[:user_name] = user_data[1]
            session[:password] = user_data[2]
            redirect_to "/selectPeriod"
        end 
    
    end

    def openSelectPeriodScreen
 
        user_data = User.getUserData("H184100001", "dvbs72bk")
        @user_name = user_data[1]#session[:user_name]
        @department_name = user_data[4] #session[:department_name]
        
        @date_array = []
        today = Date.today

        for i in 0..12 do
            date = today << i
            year = date.year.to_s
            month = date.month.to_s
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
        @users = User.getNormalUsersData("H184100001")
        render "users"
    end

end
