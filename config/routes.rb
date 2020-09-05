Rails.application.routes.draw do
  #コントローラーファイル名の先頭を小文字にしたもの
  #コントローラーファイルの名前が"Users_controller.rb"なら"users#メソッド名"
  get "/", to: "users#openLoginScreen"
  get "/login", to: "users#openLoginScreen"
  post "/login", to: "users#login"
  #post "/login", to: "sessions#createSessions"
  post "/logout", to: "sessions#deleteSessions"
  get "/selectPeriod", to: "users#openSelectPeriodScreen"
  get "/users", to: "users#getUsers"
  get "/report/:user_id", to: "reports#openReportEditScreen"
  post "/report/:user_id", to: "reports#updateState"
end
