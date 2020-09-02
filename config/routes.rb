Rails.application.routes.draw do
  #コントローラーファイル名の先頭を小文字にしたもの
  #コントローラーファイルの名前が"Users_controller.rb"なら"users#メソッド名"
  get "/login", to: "users#openLoginScreen"
  post "/login", to: "users#login"
  get "/selectPeriod", to: "users#openSelectPeriodScreen"
  post "/users", to: "users#getUsers"
  get "/report/:user_id/:date", to: "reports#openReportEditScreen"
  post "/report/:user_id/:date", to: "reports#updateState"
end
