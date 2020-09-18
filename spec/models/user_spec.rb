require "rails_helper"

#InternAppDatabase_testのusersテーブルが参照される
#discribeはテスト対象のモデル
RSpec.describe User, type: :model do
  
  #itは期待する結果
  it "idとnameの値を持つハッシュが一つだけ格納された配列が返されること" do
    user_data = User.getItem("H184200001", "abcdefg")
    expect(user_data).to eq([{"user_id"=>"H184200001", "user_name"=>"横田"}])
  end

  it "空の配列が返されること" do
    user_data = User.getItem("H184300001", "abcdefg") #ユーザーIDがusers内に存在しない
    expect(user_data).to eq([])
  end

  it "user_id, name, stateの値を持つハッシュが格納された配列が返されること" do
    users = User.getItems_withOhterTables("H184100001", "2020-9")
    expect(users).to eq([{"user_id"=>"H184100003", "name"=>"橋本", "state"=>"編集中"}, {"user_id"=>"H184100002", "name"=>"山田", "state"=>"編集中"}, {"user_id"=>"H184100004", "name"=>"川口", "state"=>"編集中"}]) #users[テスト用ユーザーのユーザーID] != nilの方が良い?(データ追加後にこのテストを実行するとエラーになる)
  end

  it "空の配列が返されること" do
    users = User.getItems_withOhterTables("H184100002", "2020-9") #マネージャーではない
    expect(users).to eq([])
  end

end
