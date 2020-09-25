Rails.application.routes.draw do
  #コントローラーファイル名の先頭を小文字にしたもの
  #コントローラーファイルの名前が"Users_controller.rb"なら"users#メソッド名"
  #メソッド名はon + <リクエストメソッド名> + <アクセス先urlパス名>とする
  get "/", to: "users#onGetLogin"
  get "/login", to: "users#onGetLogin"
  post "/login", to: "users#onPostLogin"
  get "/period", to: "users#onGetPeriod"
  post "/changePassword", to: "users#onPostChangePassword"
  get "/message", to: "messages#onGetMessage"
  get "/getMessages", to: "messages#onGetGetMessages"
  post "/sendMessage", to: "messages#onPostSendMessage"
  get "/users", to: "users#onGetUsers"
  get "/report", to: "reports#onGetReport"
  post "/report", to: "reports#onPostReport"
end
