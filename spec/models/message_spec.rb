require "rails_helper"

RSpec.describe Message, type: :model do

  from_user_id = "H184300010" 
  to_user_id = "H184200026"
  message = "テスト送信"
  date = "2020/10/11 11:20"

  it "レコードの追加" do

    User.new({id: from_user_id, name: "丸山", password: "password"})
    User.new({id: to_user_id, name: "高橋", password: "password"})

    Message.createItem(from_user_id, to_user_id, message, date)
    messages = Message.getItems(to_user_id)
    expect(messages).to include({"from_user_id"=>from_user_id, "to_user_id"=>to_user_id, "message"=>message, "date"=>date})

  end

end
