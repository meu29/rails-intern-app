class Report < ApplicationRecord

  def self.updateItem(user_id, state)

    query = "update States set state = (:state) where user_id = (:user_id)" 
    sql = ActiveRecord::Base.sanitize_sql_array([query, state: state, user_id: user_id])
    
    return ActiveRecord::Base.connection.execute(sql)

  end

end
