#他のテーブルと結合する処理を書いた際は、一旦サーバーを再起動すると良い?

#ActiveRecordも使えるようになる(継承?)
class User < ApplicationRecord
    
    #["ユーザーID", "氏名", "パスワード", "部署ID", "部署名", "その人のマネージャーのユーザーID"]
    def self.getUserData(user_id, password)
        
        query = <<-EOS
          select users.id as user_id, users.name as user_name, users.password, belongs.department_id, departments.name as department_name, belongs.manager_user_id from users
            inner join (belongs inner join departments on belongs.department_id = departments.id)
            on users.id = belongs.user_id
            where users.id = (:user_id) and users.password = (:password)
        EOS

        #select users.user_id, users.name as user_name, users.password, users.department_id, Departments.name as department_name from users 
        sql = ActiveRecord::Base.sanitize_sql_array([query, user_id: user_id, password: password])
        data = ActiveRecord::Base.connection.select_all(sql)
        
        return data.to_a[0]
    
    end

    #一般社員一覧を取得
    def self.getNormalUsersData(manager_user_id, period)

      query = <<-EOS
        select users.id as user_id, users.name, states.state from users
          inner join (belongs inner join states on belongs.user_id = states.user_id)
          on belongs.user_id = users.id
          where belongs.user_id != (:manager_user_id) and belongs.manager_user_id = (:manager_user_id) and states.period = (:period)
      EOS

      sql = ActiveRecord::Base.sanitize_sql_array([query, manager_user_id: manager_user_id, period: period])
      
      return ActiveRecord::Base.connection.select_all(sql).to_a

    end

end
