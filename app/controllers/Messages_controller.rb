class MessagesController < ApplicationController

    protect_from_forgery

    def onGetMessageContent

        session_data = Redis.current.get("user_data")

        if session_data == nil 
            return redirect_to controller: "users", action: "onGetLogin"
        end

        @user_id = JSON.parse(session_data)["user_id"]

        render "sendMessage"

    end

    def onGetGetMessages 

        messages = Message.getItems(params[:user_id])
        render :json => {messages: messages}
    
    end

    def onPostSendMessage

        Message.createItem(params[:from_user_id], params[:to_user_id], params[:message], params[:date])
        render :json => {"status": "ok"}

    end

end
