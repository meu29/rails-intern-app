#他のテーブルと結合する処理を書いた際は、一旦サーバーを再起動すると良い?

#ActiveRecordも使えるようになる(継承?)
class User < ApplicationRecord

    def self.getUserData(user_id, password)
        
        query = <<-EOS
        select Users.user_id, Users.name as user_name, Users.password, Users.department_id, Departments.name as department_name from Users 
          inner join Departments 
          on Users.department_id = Departments.id  
          where Users.user_id = (:user_id) and Users.password = (:password)
        EOS

        sql = ActiveRecord::Base.sanitize_sql_array([query, user_id: user_id, password: password])
        data = ActiveRecord::Base.connection.select_all(sql)
        
        return data.rows[0]
    
    end

    #一般社員一覧を取得
    def self.getNormalUsersData(manager_user_id)

      query = <<-EOS
        select Users.user_id, Users.name from Users
          inner join Belongs
          on Belongs.user_id = Users.user_id
          where Belongs.manager_user_id = (:manager_user_id)
      EOS

      sql = ActiveRecord::Base.sanitize_sql_array([query, manager_user_id: manager_user_id])
      data = ActiveRecord::Base.connection.select_all(sql)

      return data

    end

end
