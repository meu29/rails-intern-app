class SessionsController < ApplicationController

    protect_from_forgery 

    def createSessions

        session[:user_data] = params[:user_data]
        redirect_to "/openSelectPeriodScreen"

    end

    def deleteSessions

        session[:user_data] = nil
        redirect_to controller: "users", action: "openLoginScreen"

    end

end
