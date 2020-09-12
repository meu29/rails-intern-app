Rails.application.routes.draw do
  #コントローラーファイル名の先頭を小文字にしたもの
  #コントローラーファイルの名前が"Users_controller.rb"なら"users#メソッド名"
  #メソッド名はon + <リクエストメソッド名> + <アクセス先urlパス名>とする
  get "/", to: "users#onGetLogin"
  get "/login", to: "users#onGetLogin"
  post "/login", to: "users#onPostLogin"
  post "/logout", to: "users#onPostLogout"
  get "/period", to: "users#onGetPeriod"
  get "/users", to: "users#onGetUsers"
  get "/report", to: "reports#onGetReport"
  post "/report", to: "reports#onPostReport"
end
