#モデルを編集したら必ずサーバーを再起動する
class Report < ApplicationRecord

  def self.initItems(user_id, period)

    existing_data = getItems(user_id, period)
    
    if existing_data.length != 0
      return existing_data
    end

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
      set_data_array.push({"user_id": user_id, "period": period, "date": d, "wday": wday_array[wday_index],"start_time": nil, "finish_time": nil, "break_time": nil, "working_time": "00:00", "manager_check": "false"})
      if wday_index == 6
        wday_index = 0
      else
        wday_index += 1
      end
    end

    Report.import(set_data_array)
    
    return getItems(user_id, period)
    
  end

  def self.getItems(user_id, period)

    query =<<-EOS
      select date, wday, start_time, finish_time, break_time, working_time from reports
        where user_id = (:user_id) and period = (:period)
    EOS
    sql = ActiveRecord::Base.sanitize_sql_array([query, user_id: user_id, period: period])
    
    return ActiveRecord::Base.connection.select_all(sql).to_a

  end
  
  def self.updateItems(user_id, date_array, period, start_time_array, finish_time_array, break_time_array)

    (0..start_time_array.length - 1).each do |i|
      if start_time_array[i].length == 5 and finish_time_array[i].length == 5 and break_time_array[i].length == 5 #01:00, 13:00等 => 文字数5
        time_dif = Time.parse(finish_time_array[i]) - Time.parse(start_time_array[i])
        working_time = (time_dif / 3600).floor.to_s + ":" + ((time_dif % 3600) / 60).floor.to_s
        logger.debug(working_time)
        query = <<-EOS
         update reports set start_time = (:start_time), finish_time = (:finish_time), break_time = (:break_time), working_time = (:working_time)
          where user_id = (:user_id) and date = (:date) and period = (:period)
        EOS
        sql = ActiveRecord::Base.sanitize_sql_array([query, start_time: start_time_array[i], finish_time: finish_time_array[i], break_time: break_time_array[i], working_time: working_time, user_id: user_id, date: date_array[i], period: period])
        ActiveRecord::Base.connection.execute(sql)
      end
    end

    return

  end

end