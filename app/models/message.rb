class Message < ApplicationRecord

    #updateItemは無し

    def self.createItem(from_user_id, to_user_id, message, date)

        query = "insert into messages (from_user_id, to_user_id, message, date) values (:from_user_id, :to_user_id, :message, :date)"
        sql = ActiveRecord::Base.sanitize_sql_array([query, from_user_id: from_user_id, to_user_id: to_user_id, message: message, date: date])
        ActiveRecord::Base.connection.execute(sql)
    
    end

    def self.getItems(user_id, user_id_type)

        query = "select users.name, messages.message, messages.date from messages inner join users"

        #where from_user_id = (:user_id) or to_user_id = (:user_id)だと分けるのが面倒なので1回の実行につき片方のみ取得
        if user_id_type == "from_user_id"
            query += " on messages.to_user_id = users.id where from_user_id = (:user_id)"
        else
            query += " on messages.from_user_id = users.id where to_user_id = (:user_id)"
        end

        sql = ActiveRecord::Base.sanitize_sql_array([query, user_id: user_id])
        
        return ActiveRecord::Base.connection.select_all(sql).to_a

    end

    def self.deleteItem

    end

end
