class Department < ApplicationRecord

    def self.getItem(name)

      query = "select id from departments where name = (:name)"

      sql = ActiveRecord::Base.sanitize_sql_array([query, name: name])
      return ActiveRecord::Base.connection.select_all(sql).to_a

    end

    def self.getItem_withOtherTables(user_id)

      query = <<-EOS
        select departments.name as department_name, belongs.manager_user_id from departments
          inner join belongs on departments.id = belongs.department_id
          where belongs.user_id = (:user_id)
      EOS

      sql = ActiveRecord::Base.sanitize_sql_array([query, user_id: user_id])
      return ActiveRecord::Base.connection.select_all(sql).to_a
    
    end
      
end
