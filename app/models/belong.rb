class Belong < ApplicationRecord

    def self.createItem(user_id, manager_user_id, department_id)

        query = "insert into belongs (user_id, manager_user_id, department_id) values (:user_id, :manager_user_id, :department_id)"
        sql = ActiveRecord::Base.sanitize_sql_array([query, user_id: user_id, manager_user_id: manager_user_id, department_id: department_id])

        ActiveRecord::Base.connection.execute(sql)

    end

    def self.getItem(department_id)

        query =<<-EOS
          select user_id, manager_user_id from belongs
            where department_id = (:department_id)
        EOS

        sql = sql = ActiveRecord::Base.sanitize_sql_array([query, department_id: department_id])
        return ActiveRecord::Base.connection.select_all(sql).to_a

    end

    def self.getItems_withUsersTable(manager_user_id)

        query =<<-EOS 
            select belongs.user_id, users.name from belongs
            inner join users 
            on belongs.user_id = users.id 
            where belongs.manager_user_id = (:manager_user_id) and belongs.user_id != (:manager_user_id)
        EOS
          
        sql = ActiveRecord::Base.sanitize_sql_array([query, manager_user_id: manager_user_id])
        
        return ActiveRecord::Base.connection.select_all(sql).to_a

    end

    def self.deleteItem(user_id, manager_user_id)

        query = "delete from belongs where user_id = (:user_id) and manager_user_id = (:manager_user_id)"
        sql = ActiveRecord::Base.sanitize_sql_array([query, user_id: user_id, manager_user_id: manager_user_id])

        ActiveRecord::Base.connection.execute(sql)

    end

end
