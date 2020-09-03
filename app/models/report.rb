#モデルを編集したら必ずサーバーを再起動する
class Report < ApplicationRecord

  def self.createItem(user_id, period)

    query = <<-EOS
      insert into Reports (user_id, period, start_time, finish_time, break_time, manager_check)
        VALUES ((:user_id), (:period), null, null, null, 0)
    EOS

    sql = ActiveRecord::Base.sanitize_sql_array([query, user_id: user_id, period: period])
    
    return ActiveRecord::Base.connection.execute(sql)

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
