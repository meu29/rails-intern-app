class Department < ApplicationRecord

    def self.getItem(user_id)

      query = <<-EOS
        select departments.name from departments
          inner join belongs on departments.id = belongs.department_id
          where belongs.user_id = (:user_id)
      EOS

      sql = ActiveRecord::Base.sanitize_sql_array([query, user_id: user_id])
      return ActiveRecord::Base.connection.select_all(sql).to_a
    
    end
      
end
