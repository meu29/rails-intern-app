#動作確認済み
require "rails_helper"

RSpec.describe Department, type: :model do

  user_id = "H18419999"
  user_name = "佐藤"
  manager_user_id = "H184100001"
  department_id = "A103"
  department_name = "財務部"

  it "ハッシュが一つだけ格納された配列が返される" do

    Department.new({name: department_name, id: department_id}).save
    Belong.new({user_id: user_id, manager_user_id: manager_user_id, department_id: department_id}).save

    user_data = Department.getItem_withOtherTables(user_id)
    expect(user_data).to eq([{"department_name"=>department_name, "manager_user_id"=>manager_user_id}])
  
  end
  
  it "空の配列が返される" do
    users_data = Department.getItem_withOtherTables(user_id)
    expect(users_data).to eq([])
  end

end
