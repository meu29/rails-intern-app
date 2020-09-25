class MessagesController < ApplicationController

    protect_from_forgery

    def onGetMessage

        session_data = Redis.current.get("user_data")

        if session_data == nil 
            return redirect_to controller: "users", action: "onGetLogin"
        end

        @user_id = JSON.parse(session_data)["user_id"]

        render "sendMessage"

    end

    def onGetGetMessages 

        user_id = params[:user_id]

        sended_messages = Message.getItems(user_id, "from_user_id")
        received_messages = Message.getItems(user_id, "to_user_id")
        
        render :json => {"sended_messages": sended_messages, "received_messages": received_messages}
    
    end

    def onPostSendMessage
        Message.createItem(params[:from_user_id], params[:to_user_id], params[:message], params[:date])
        render :json => {"status": "ok"}
    end

end
