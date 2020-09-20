require "rails_helper"

#bundle exec rspec /home/meu/ドキュメント/RailsInternApp/spec/features/user_spec.rb
#ログアウトは本来自動で行うので、手動実行でのテストはしない

feature "User", type: :feature do

  scenario "ログインの失敗後、再度ログイン画面を表示" do

    visit "/"
    click_button "ログイン"
    expect(page).to have_content("ユーザーIDかパスワードが間違っています")

  end

  scenario "ログインの成功後、期間選択画面に遷移" do
    
    visit "/"
    fill_in "user_id", with: "H184100001"
    fill_in "password", with: "dvbs72bk"
    click_button "ログイン"
    expect(page).to have_content("勤怠報告期間選択")
    Redis.current.del("user_data")

  end

  scenario ""

  

end