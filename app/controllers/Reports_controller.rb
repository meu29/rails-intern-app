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

  def updateState

    operation = params[:operation]
    user_id = params[:user_id]
    period = params[:period]
    
    #キャンセルならDBを更新しない(一般・マネージャー共通)
    #マネージャー側の操作
    if operation == "承認" 
      State.updateItem(user_id, period, "承認済み")
    elsif operation == "差し戻し"
      State.updateItem(user_id, period, "編集中")
    #一般社員側の操作
    elsif operation == "承認依頼"
      Report.updateItems(user_id, params[:date], period, params[:start_time], params[:finish_time], params[:break_time])
      State.updateItem(user_id, period, "承認依頼中")
    elsif operation == "保存"
      Report.updateItems(user_id, period, params[:start_time])
    end

    redirect_to controller: "users", action: "openSelectPeriodScreen"

  end

end

'''
Parameters: {"authenticity_token"=>"tlGvr07rpMPdx1m7kpxVHoZet8nz3zdAsRRwmjPa2tnrmv91GXCeWRJ/kgI4csqpKb+oNcXKGbfMUVhod029Gg==", "manager_check"=>{"1"=>"0", "2"=>"0", "3"=>"1", "4"=>"0", "5"=>"0", "6"=>"0", "7"=>"0", "8"=>"0", "9"=>"0", "10"=>"0", "11"=>"0", "12"=>"0", "13"=>"0", "14"=>"0", "15"=>"0", "16"=>"0", "17"=>"0", "18"=>"0", "19"=>"0", "20"=>"0", "21"=>"0", "22"=>"0", "23"=>"0", "24"=>"0", "25"=>"0", "26"=>"0", "27"=>"0", "28"=>"0", "29"=>"0", "30"=>"0"}, "time"=>"", "operation"=>{"{:value=>\"承認\"}"=>""}, "commit"=>"承認", "user_id"=>"H184100003", "period"=>"2020-9"}
'''
