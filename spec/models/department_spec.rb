require "rails_helper"

RSpec.describe Department, type: :model do

  it "departments.nameとbelongs.manager_user_idの値を持つハッシュが一つだけ格納された配列が返される" do
    user_data = Department.getItem_withOtherTables("H184100002")
    expect(user_data).to eq([{"department_name"=>"営業部", "manager_user_id"=>"H184100001"}])
  end

  it "空の配列が返される" do
    users_data = Department.getItem_withOtherTables("H18419999") #存在しないユーザーID
    expect(users_data).to eq([])
  end

end
