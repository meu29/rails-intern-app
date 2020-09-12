require("date")

class ReportsController < ApplicationController

  protect_from_forgery

  def onGetReport
    
    #ここでセッションを使ってはいけない
    @user_id = params[:user_id]
    @period = params[:period]

    values = Department.getItem_withOtherTables(@user_id)[0]
    @department_name = values["department_name"]

    @report_data_array = Report.getItems(@user_id, @period)
    state = State.getItem(@user_id, @period)[0]["state"]

    session_data = JSON.parse(Redis.current.get("user_data"))

    if session_data["user_id"] == values["manager_user_id"]
      user_data_array = User.getItems_withOhterTables(values["manager_user_id"], @period)
      (0..user_data_array.length - 1).each do |i|
        if user_data_array[i]["user_id"] == @user_id
          @user_name = user_data_array[i]["name"]
          break
        end
      end
      render "report(manager)"
    else
      @user_name = session_data["user_name"]
      if state == "承認済み" or state == "承認依頼中" 
        render "report(normal)"
      else
        render "report(normal_edit)"
      end
    end

  end

  def onPostReport

    #params[:manager_check] => チェックされた -> "on" されなかった -> "true"(文字列)
    #保存かキャンセルならstatesテーブルを更新しない(保存 => 一般のみ, キャンセル => 一般・マネージャー共通)
    
    #マネージャー側の操作
    if params[:approval] != nil
      State.updateItem(params[:user_id], params[:period], "承認済み")
      Report.updateItems_ByManagerUser(params[:user_id], params[:date], params[:period], params[:manager_check_value])
    elsif params[:remand] != nil
      State.updateItem(params[:user_id], params[:period], "編集中")
      logger.debug(params)
      Report.updateItems_ByManagerUser(params[:user_id], params[:date], params[:period], params[:manager_check_value])
    #一般社員側の操作
    elsif params[:approval_request] != nil
      State.updateItem(params[:user_id], params[:period], "承認依頼中")
      Report.updateItems_ByNormalUser(params[:user_id], params[:date], params[:period], params[:start_time], params[:finish_time], params[:break_time])
    elsif params[:save] != nil
      Report.updateItems_ByNormalUser(params[:user_id], params[:date], params[:period], params[:start_time], params[:finish_time], params[:break_time])
    end

    redirect_to controller: "users", action: "onGetPeriod"

  end

end