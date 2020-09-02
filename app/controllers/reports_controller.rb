require("date")

class ReportsController < ApplicationController

  protect_from_forgery

  def openReportEditScreen
    
    @end_of_month_date = Date.new(Time.now.year, Time.now.month, -1).day
    render "reportEdit"

  end

  def updateState

    operation = params[:operation];
    user_id = params[:user_id]
    
    if operation == "承認" 
      Report.updateItem(user_id, "承認済み", date)
    elsif operation == "差し戻し"
      Report.updateItem(user_id, "編集中", date)
    end
    
    render "reportEdit"
    #redirect "selectPeriod" #redirect "/users" sessionに保存したユーザーIDを使用
  
  end

end
