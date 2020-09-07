require("date")

class ReportsController < ApplicationController

  protect_from_forgery

  def openReportEditScreen
    
    #マネージャーは自分以外のユーザーIDを参照するのでセッションは☓
    @user_id = params[:user_id]
    @period = params[:period]
    @department_name = Department.getItem(@user_id)[0]["name"]
    @report_data_array = Report.initItems(@user_id, @period)

    #user_data = User.getItem
    
    state = State.getItem(@user_id, @period)[0]["state"]

    if session[:user_data]["user_id"] == session[:user_data]["manager_user_id"]
      render "report(manager)"
    else
      if state == "承認済み" or state == "承認依頼中" 
        render "report(normal)"
      else
        render "report(normal_edit)"
      end
    end

  end

  def updateStateAndReport

    #保存かキャンセルならstatesテーブルを更新しない(保存 => 一般のみ, キャンセル => 一般・マネージャー共通)
    #マネージャー側の操作
    if params[:approval] != nil
      State.updateItem(params[:user_id], params[:period], "承認済み")
      Report.updateItemsByManagerUser(params[:user_id], params[:date], params[:period], params[:manager_check])
    elsif params[:remand] != nil
      State.updateItem(params[:user_id], params[:period], "編集中")
      Report.updateItemsByManagerUser(params[:user_id], params[:date], params[:period], params[:manager_check])
    #一般社員側の操作
    elsif params[:approval_request] != nil
      State.updateItem(params[:user_id], params[:period], "承認依頼中")
      Report.updateItemsByNormalUser(params[:user_id], params[:date], params[:period], params[:start_time], params[:finish_time], params[:break_time])
    elsif params[:save] != nil
      Report.updateItemsByNormalUser(params[:user_id], params[:date], params[:period], params[:start_time], params[:finish_time], params[:break_time])
    end

    redirect_to controller: "users", action: "openSelectPeriodScreen"

  end

end