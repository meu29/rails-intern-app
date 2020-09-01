#require("/home/meu/ドキュメント/RailsInternApp/app/models/user.rb")
#データベース.テーブル => sample_development.Users

class NewController < ApplicationController

    protect_from_forgery 

    def login
        #render text: 
        @message = User.getUserData("aiueo12345")
        render "login"
    end
    
    '''
    def post
        render template: "new/index"
        #render html: params[:user_name]
    end
    '''

end
