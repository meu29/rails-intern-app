#モデルを編集したら必ずサーバーを再起動する
class Report < ApplicationRecord

  def self.createItem(user_id, date)
    '''
    splited_data_string = @date.split("-")
    @set_data_array = 
    
    end_of_month_date = Date.new(splited_data_string[0],  splited_data_string[1], -1).day
    
    (1..end_of_month_date).each do |i|
      set_data_array.push([i])    '''
    query = "insert into InsertTest (value1, value2) values (:data)";
    sql = ActiveRecord::Base.sanitize_sql_array([query, data: "('c', 'd'), ('e', 'f')"])
    
    return ActiveRecord::Base.connection.execute(sql)

  end

  def self.updateItem(user_id, state)

    query = "update States set state = (:state) where user_id = (:user_id)" 
    sql = ActiveRecord::Base.sanitize_sql_array([query, state: state, user_id: user_id])
    
    return ActiveRecord::Base.connection.execute(sql)

  end

end
