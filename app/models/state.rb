class State < ApplicationRecord

    def self.updateItem(user_id, period, state)

        query = <<-EOS
          update states set state = (:state)
            where user_id = (:user_id) and period = (:period)
        EOS
        
        sql = ActiveRecord::Base.sanitize_sql_array([query, state: state, user_id: user_id, period: period])  
        return ActiveRecord::Base.connection.execute(sql) 
      
    end

end
