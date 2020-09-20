#動作確認済み
require "rails_helper"

#一日ごとに値を切り替える
def makeArray(element_x, element_y, cnt)

  array = []

  (0..cnt - 1).each do |num|
    if num % 2 == 0
      array.push(element_x)
    else
      array.push(element_y)
    end
  end

  return array

end

#createItem()とgetItems()は他のメソッドから呼び出されるので、単体でのテストを省略
RSpec.describe Report, type: :model do

  user_id = "H184300001"
  period = "2020-10"
  day = 31 #2020年10月は31日まで
  start_time_array = makeArray("12:00", "13:00", day)
  finish_time_array = makeArray("19:00", "19:30", day)
  finish_time_array[2] = "08:00"
  break_time_array = makeArray(90, 75, day)
  break_time_array[3] = 99999
  date_array = []
  manager_check_array = makeArray(true, false, day)
  
  (1..day).each do |num|
    date_array.push(num.to_s)
  end

  #ByNormalUserとByManagerUserでテストを分けると、ByManagerUserのテストでもByNormalUserを実行しなければいけないので一つのテストにまとめる。
  it "報告が登録され、日毎の勤務時間が算出される。更にマネージャーによる日毎の報告承認が反映される。" do

    Report.createItems(user_id, period)
    Report.updateItems_ByNormalUser(user_id, date_array, period, start_time_array, finish_time_array, break_time_array)
    Report.updateItems_ByManagerUser(user_id, date_array, period, manager_check_array)
    
    reports = Report.getItems(user_id, period)

    #正常
    expect(reports[0]["working_time"]).to eq(5.5)
    expect(reports[0]["manager_check"]).to eq(1)
    expect(reports[1]["working_time"]).to eq(5.25)
    expect(reports[1]["manager_check"]).to eq(0)

    #開始時刻と終了時刻を逆に書いた場合
    expect(reports[2]["working_time"]).to eq(0.0)
    #休憩時間を勤務時間が上回った場合
    expect(reports[3]["working_time"]).to eq(0.0)
  
  end

end
