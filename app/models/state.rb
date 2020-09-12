class State < ApplicationRecord

    def self.createItem(user_id, period)

        query = "insert into states (user_id, state, period) values ( :user_id, '編集中', :period)"
        sql = ActiveRecord::Base.sanitize_sql_array([query, user_id: user_id, period: period])

        ActiveRecord::Base.connection.execute(sql)
        
        return

    end 

    def self.getItem(user_id, period)

        query = "select state from states where user_id = (:user_id) and period = (:period)"
        sql = ActiveRecord::Base.sanitize_sql_array([query, user_id: user_id, period: period])
        result = ActiveRecord::Base.connection.select_all(sql).to_a

        if result.length != 0
            return result
        else
            createItem(user_id, period)
            return [{"state"=>"編集中"}]
        end
    
    end

    def self.updateItem(user_id, period, state)

        query = "update states set state = (:state) where user_id = (:user_id) and period = (:period)"
        sql = ActiveRecord::Base.sanitize_sql_array([query, state: state, user_id: user_id, period: period])  
        ActiveRecord::Base.connection.execute(sql) 

        return
      
    end

end
