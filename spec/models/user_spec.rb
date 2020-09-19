#動作確認済み
require "rails_helper"

#InternAppDatabase_testのusersテーブルが参照される
#discribeはテスト対象のモデル
RSpec.describe User, type: :model do

  user_id = "H184300001"
  user_name = "佐藤"
  manager_user_id = "H184100001"
  password = "abcdefg"
  period = "2020-9"
  
  #itは期待する結果
  it "idとnameの値を持つハッシュが一つだけ格納された配列が返されること" do

    #user.rbではレコードを追加するメソッドを定義していないので、新しく作る
    User.new({id: user_id, name: user_name, password: password}).save
    user_data = User.getItem(user_id, password)
    expect(user_data).to eq([{"user_id"=>user_id, "user_name"=>user_name}])
  
  end

  it "空の配列が返されること" do

    #テストでは実際にデータが追加されるわけではない(?)ので、上のテストを実行した後はusersテーブル内にuser_idが存在しない状態
    user_data = User.getItem(user_id, password)
    expect(user_data).to eq([])
  
  end
  
  it "新しく追加されたユーザーの情報を含むハッシュを取得すること" do

    User.new({id: user_id, name: user_name, password: password}).save
    Belong.new({user_id: user_id, manager_user_id: manager_user_id, department_id: "A101"}).save
    
    State.createItem(user_id, period)
    
    users = User.getItems_withOhterTables(manager_user_id, period)
    expect(users).to include({"user_id"=>user_id, "name"=>user_name, "state"=>"編集中"})
  
  end

  it "空の配列が返されること" do

    users = User.getItems_withOhterTables(user_id, period)
    expect(users).to eq([])
  
  end
  
end
