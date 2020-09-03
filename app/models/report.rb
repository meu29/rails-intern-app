#モデルを編集したら必ずサーバーを再起動する
class Report < ApplicationRecord

  def self.createItem(user_id, period)

    self.table_name = "Reports"

    splited_period = period.split("-")
    end_of_month_date = Date.new(splited_period[0].to_i, splited_period[1].to_i, -1).day
    set_data_array = []
  
    (1..end_of_month_date).each do |d|
      set_data_array.push({"user_id": user_id, "period": period, "date": d, "start_time": nil, "finish_time": nil, "break_time": nil, "manager_check": "false"})
    end

    return Report.import(set_data_array)

  end

  def self.getItem(user_id)

    query = "select * from Reports"
    sql = ActiveRecord::Base.sanitize_sql_array([query, user_id: user_id])
    
    return ActiveRecord::Base.connection.select_all(sql).to_a

  end
  

  def self.updateItem(user_id, state)

    query = "update States set state = (:state) where user_id = (:user_id)" 
    sql = ActiveRecord::Base.sanitize_sql_array([query, state: state, user_id: user_id])
    
    return ActiveRecord::Base.connection.execute(sql)

  end

end
