Rails.application.routes.draw do
  #コントローラーファイル名の先頭を小文字にしたもの
  #コントローラーファイルの名前が"Users_controller.rb"なら"users#メソッド名"
  get "/login", to: "users#openLoginScreen"
  post "/login", to: "users#login"
  post "/logout", to: "users#logout"
  get "/selectPeriod", to: "users#openSelectPeriodScreen"
  get "/users", to: "users#getUsers"
  get "/report/:user_id/:period", to: "reports#openReportEditScreen"
  post "/report/:user_id/:period", to: "reports#updateState"
end
