#動作確認済み
require "rails_helper"

#getItem()単体でのテストはしない
RSpec.describe State, type: :model do
  
  user_id = "H184199999"
  period = "2020-9"

  it "stateテーブルに新しいレコードを追加する" do
    State.createItem(user_id, period)
    state = State.getItem(user_id, period);
    expect(state).to eq([{"state"=>"編集中"}])
  end

  it "stateテーブルのレコードを更新する" do
    #テストでは実際にデータが追加されるわけではない(?)ので、再度追加メソッドを実行する
    State.createItem(user_id, period)
    State.updateItem(user_id, period, "承認済み")
    state = State.getItem(user_id, period);
    expect(state).to eq([{"state"=>"承認済み"}])
  end

end
