require "rails_helper"

RSpec.describe Department, type: :model do

  user_id = "H18419999"
  user_name = "佐藤"
  manager_user_id = "H184100001"
  department_id = "A103"
  department_name = "財務部"

  it "departments.nameとbelongs.manager_user_idの値を持つハッシュが一つだけ格納された配列が返される" do
    Department.new({name: department_name, id: department_id})
    Belong.new({user_id: user_id, manager_user_id: manager_user_id, department_id: department_id})
    user_data = Department.getItem_withOtherTables(user_id)
    expect(user_data).to eq([{"department_name"=>department_name, "manager_user_id"=>manager_user_id}])
  end
  
  it "空の配列が返される" do
    users_data = Department.getItem_withOtherTables(user_id) #存在しないユーザーID
    expect(users_data).to eq([])
  end

end
