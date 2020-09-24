class Message < ApplicationRecord

    #updateItemは無し

    def self.createItem(from_user_id, to_user_id, message, date)

        query = "insert into messages (from_user_id, to_user_id, message, date) values (:from_user_id, :to_user_id, :message, :date)"
        sql = ActiveRecord::Base.sanitize_sql_array([query, from_user_id: from_user_id, to_user_id: to_user_id, message: message, date: date])
        ActiveRecord::Base.connection.execute(sql)
    
    end

    def self.getItems(to_user_id)

        query = "select * from messages where to_user_id = (:to_user_id)"
        sql = ActiveRecord::Base.sanitize_sql_array([query, to_user_id: to_user_id])
        
        return ActiveRecord::Base.connection.select_all(sql).to_a

    end

    def self.deleteItem

    end

end
