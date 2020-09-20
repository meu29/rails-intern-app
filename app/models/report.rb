#モデルを編集したら必ずサーバーを再起動する
class Report < ApplicationRecord

  def self.createItems(user_id, period)

    splited_period = period.split("-")
    year = splited_period[0].to_i
    month = splited_period[1].to_i
    
    #月末の日付を取得(28, 30, 31のどれか)
    end_of_month_date = Date.new(year, month, -1).day
    
    #月始めの曜日を取得(0 ~ 6 0が日曜、1が月曜、..)
    wday_array = ["日", "月", "火", "水", "木", "金", "土"]
    wday_index = Date.new(year, month, 1).wday

    set_data_array = []
  
    (1..end_of_month_date).each do |d|
      set_data_array.push({"user_id": user_id, "period": period, "date": d, "wday": wday_array[wday_index], "start_time": nil, "finish_time": nil, "break_time": nil, "working_time": 0.0, "manager_check": false})
      if wday_index == 6
        wday_index = 0
      else
        wday_index += 1
      end
    end

    Report.import(set_data_array)
    
    return
    
  end

  def self.getItems(user_id, period)

    query =<<-EOS
      select date, wday, start_time, finish_time, break_time, working_time, manager_check from reports
        where user_id = (:user_id) and period = (:period)
    EOS
    sql = ActiveRecord::Base.sanitize_sql_array([query, user_id: user_id, period: period])
    
    result = ActiveRecord::Base.connection.select_all(sql).to_a

    if result.length == 0
      createItems(user_id, period)
      return getItems(user_id, period)
    else 
      return result
    end

  end

  def self.updateItems_ByNormalUser(user_id, date_array, period, start_time_array, finish_time_array, break_time_array)

    (0..start_time_array.length - 1).each do |i|

      working_time = (Time.parse(finish_time_array[i]) - Time.parse(start_time_array[i])) / 3600
      working_time -= break_time_array[i].to_f / 60.0
      
      #開始時刻と終了時刻を逆にする、勤務時間よりも休憩時間の方が多いといった入力ミスなど
      if working_time < 0
        start_time_array[i] = "00:00"
        finish_time_array[i] = "00:00"
        break_time_array[i] = 0
        working_time = 0
      end
        
      query = <<-EOS
        update reports set start_time = (:start_time), finish_time = (:finish_time), break_time = (:break_time), working_time = (:working_time)
          where user_id = (:user_id) and date = (:date) and period = (:period)
      EOS
      
      sql = ActiveRecord::Base.sanitize_sql_array([query, start_time: start_time_array[i], finish_time: finish_time_array[i], break_time: break_time_array[i], working_time: working_time, user_id: user_id, date: date_array[i], period: period])
      ActiveRecord::Base.connection.execute(sql)
    
    end

  end

  def self.updateItems_ByManagerUser(user_id, date_array, period, manager_check_array)

    (0..manager_check_array.length - 1).each do |i|
      query = <<-EOS
        update reports set manager_check = (:manager_check)
          where user_id = (:user_id) and date = (:date) and period = (:period)
      EOS
      #文字列のtrue/falseをboolean型に変換
      manager_check = ActiveRecord::Type::Boolean.new.cast(manager_check_array[i])
      sql = ActiveRecord::Base.sanitize_sql_array([query, user_id: user_id, date: date_array[i], period: period, manager_check: manager_check])
      ActiveRecord::Base.connection.execute(sql)
    end

    return

  end

end