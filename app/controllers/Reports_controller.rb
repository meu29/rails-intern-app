require("date")

class ReportsController < ApplicationController

  protect_from_forgery

  def openReportEditScreen
    
    @user_id = params[:user_id]
    @date = params[:date]
    Report.createItem(@user_id, @date)

    render "reportEdit"

  end

  def updateState

    operation = params[:operation]
    @user_id = params[:user_id]
    @date = params[:date]
    
    if operation == "承認" 
      Report.updateItem(user_id, "承認済み", date)
    elsif operation == "差し戻し"
      Report.updateItem(user_id, "編集中", date)
    end
    
    render "reportEdit"
    #redirect "selectPeriod" #redirect "/users" sessionに保存したユーザーIDを使用
  
  end

end
