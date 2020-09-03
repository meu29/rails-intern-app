require("date")

class ReportsController < ApplicationController

  protect_from_forgery

  def openReportEditScreen
    
    @user_id = params[:user_id]
    @period = "1999-01" #params[:date]
    @message = Report.createItem(@user_id, @period)
    #@message = Report.getItem(@user_id)

    if session[:user_data]["user_id"] == session[:user_data]["manager_user_id"]
      render "report(manager)"
    else
      render "report(normal)"
    end

  end

  def updateState

    operation = params[:operation]
    user_id = params[:user_id]
    period = params[:period]
    
    #マネージャー側の操作
    if operation == "承認" 
      Report.updateItem(user_id, "承認済み", period)
    elsif operation == "差し戻し"
      Report.updateItem(user_id, "編集中", period)
    '''一般社員側の操作
    elsif operation == "承認依頼"
      Report.updateItem(user_id, "編集中", date)
    elsif operation == "保存"
      Report.updateItem(user_id, "編集中", date)
    '''
    end
    
    redirect_to controller: "users", action: "openSelectPeriodScreen"

  end

end
