class BelongsController < ApplicationController

    protect_from_forgery

    def onGetMember

        user_data = Redis.current.get("user_data")

        if user_data == nil 
            return redirect_to controller: "users", action: "onGetLogin"
        end

        user_data = JSON.parse(user_data)

        @user_name = user_data["user_name"]
        @department_name = user_data["department_name"]
        @users = Belong.getItems_withUsersTable(user_data["user_id"])
        @test = User.getItem_withBelongTable()

        render "member"

    end

    def onPostMember

        user_data = Redis.current.get("user_data")

        if user_data == nil 
            return redirect_to controller: "users", action: "onGetLogin"
        end

        user_data = JSON.parse(user_data)

        if params[:operation] == "登録"
            department_id = Department.getItem(params[:department_name])[0]["id"]
            Belong.createItem(params[:user_id], user_data["user_id"], department_id)
        else 
            Belong.deleteItem(params[:user_id], user_data["user_id"])
        end

        @user_name = user_data["user_name"]
        @department_name = user_data["department_name"]
        @users = Belong.getItems_withUsersTable(user_data["user_id"])

        render "member"

    end


end
