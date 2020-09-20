#他のテーブルと結合する処理を書いた際は、一旦サーバーを再起動すると良い?

#ActiveRecordも使えるようになる(継承?)
class User < ApplicationRecord

    #self付きがクラスメソッド、付いてないのがインスタンスメソッド
    def self.getItem(user_id, password)
        
        query = <<-EOS
          select id as user_id, name as user_name from users
            where id = (:user_id) and password = (:password)
        EOS

        sql = ActiveRecord::Base.sanitize_sql_array([query, user_id: user_id, password: password])
        
        return ActiveRecord::Base.connection.select_all(sql).to_a
    
    end

    #一般社員一覧を取得
    def self.getItems_withOhterTables(manager_user_id, period, start_index = 1)

      query = <<-EOS
        select users.id as user_id, users.name, states.state from users
          inner join (belongs inner join states on belongs.user_id = states.user_id)
          on belongs.user_id = users.id
          where belongs.user_id != (:manager_user_id) and belongs.manager_user_id = (:manager_user_id) and states.period = (:period)
          limit :start_index, 10
      EOS

      sql = ActiveRecord::Base.sanitize_sql_array([query, manager_user_id: manager_user_id, period: period, start_index: (start_index  - 1) * 10])
      
      return ActiveRecord::Base.connection.select_all(sql).to_a

    end

end
