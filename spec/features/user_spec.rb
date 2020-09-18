require "rails_helper"

#bundle exec rspec /home/meu/ドキュメント/RailsInternApp/spec/features/user_spec.rb

feature "User", type: :feature do

  scenario "期間の選択後、社員一覧画面が表示されるか" do
    visit "/period"
    click_on "決定"
    expect(page).to have_content("社員番号")
  end

end