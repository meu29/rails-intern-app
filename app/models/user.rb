#他のテーブルと結合する処理を書いた際は、一旦サーバーを再起動すると良い?

#ActiveRecordも使えるようになる(継承?)
class User < ApplicationRecord
    
    #["ユーザーID", "氏名", "パスワード", "部署ID", "部署名", "その人のマネージャーのユーザーID"]
    def self.getUserData(user_id, password)
        
        query = <<-EOS
          select Users.id as user_id, Users.name as user_name, Users.password, Belongs.department_id, Departments.name as department_name, Belongs.manager_user_id from Users
            inner join (Belongs inner join Departments on Belongs.department_id = Departments.id)
            on Users.id = Belongs.user_id
            where Users.id = (:user_id) and Users.password = (:password)
        EOS

        #select Users.user_id, Users.name as user_name, Users.password, Users.department_id, Departments.name as department_name from Users 
        sql = ActiveRecord::Base.sanitize_sql_array([query, user_id: user_id, password: password])
        data = ActiveRecord::Base.connection.select_all(sql)
        
        return data.to_a[0]
    
    end

    #一般社員一覧を取得
    #user_idとmanager_user_idが同じ -> そのuser_idの人はマネージャー
    def self.getNormalUsersData(manager_user_id, date)

      query = <<-EOS
        select Users.id as user_id, Users.name, States.state from Users
          inner join (Belongs inner join States on Belongs.user_id = States.user_id)
          on Belongs.user_id = Users.id
          where Belongs.user_id != (:manager_user_id) and Belongs.manager_user_id = (:manager_user_id) and States.date = (:date)
      EOS

      sql = ActiveRecord::Base.sanitize_sql_array([query, manager_user_id: manager_user_id, date: date])
      data = ActiveRecord::Base.connection.select_all(sql)
      
      return data.to_a

    end

end
