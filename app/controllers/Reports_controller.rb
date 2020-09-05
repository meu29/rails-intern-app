require("date")

class ReportsController < ApplicationController

  protect_from_forgery

  def openReportEditScreen
    
    @user_id = params[:user_id]
    @period = params[:period] 
    @report_data_array = Report.initItems(@user_id, @period)

    if session[:user_data]["user_id"] == session[:user_data]["manager_user_id"]
      render "report(manager)"
    else
      render "report(normal)"
    end

  end

  def updateCheck

  end

  def updateState

    operation = params[:operation]
    user_id = params[:user_id]
    period = params[:period]
    
    #マネージャー側の操作
    if operation == "承認" 
      logger.debug(params)
      #Report.updateItem(user_id, "承認済み", period)
      redirect_to controller: "users", action: "openSelectPeriodScreen"
    elsif operation == "差し戻し"
      Report.updateItem(user_id, "編集中", period)
    #一般社員側の操作
    elsif operation == "承認依頼"
      Report.updateItems(user_id, params[:date], period, params[:start_time])
      #Report.updateItem(user_id, "編集中", date)
    elsif operation == "保存"
      Report.updateItems(user_id, period, params[:start_time])
    end
    
    #キャンセルなら何もしない(マネージャー、一般共通)
    redirect_to controller: "users", action: "openSelectPeriodScreen"

  end

end

'''
Parameters: {"authenticity_token"=>"tlGvr07rpMPdx1m7kpxVHoZet8nz3zdAsRRwmjPa2tnrmv91GXCeWRJ/kgI4csqpKb+oNcXKGbfMUVhod029Gg==", "manager_check"=>{"1"=>"0", "2"=>"0", "3"=>"1", "4"=>"0", "5"=>"0", "6"=>"0", "7"=>"0", "8"=>"0", "9"=>"0", "10"=>"0", "11"=>"0", "12"=>"0", "13"=>"0", "14"=>"0", "15"=>"0", "16"=>"0", "17"=>"0", "18"=>"0", "19"=>"0", "20"=>"0", "21"=>"0", "22"=>"0", "23"=>"0", "24"=>"0", "25"=>"0", "26"=>"0", "27"=>"0", "28"=>"0", "29"=>"0", "30"=>"0"}, "time"=>"", "operation"=>{"{:value=>\"承認\"}"=>""}, "commit"=>"承認", "user_id"=>"H184100003", "period"=>"2020-9"}
'''
