railsで勤怠管理アプリを作る

<img src="https://user-images.githubusercontent.com/39718781/94340660-88eae580-003e-11eb-9777-48367aa45bb9.png" width="500">

##やること・メモ<br>
・intern_db.dumpをsqlにインポート <br>
 sudo mysql -u newuser -p import先データベース名 < '/home/meu/ドキュメント/RailsInternApp/intern_db.dump' <br>
・sudo apt install redis-cli でredisをインストール<br>
・データベースは本番用(InternAppDatabase)とテスト用(InternAppDatabase_test)の2種類<br>
・テスト駆動開発 -> 先にmodel名_spec.rbを書く => これに受かるようにmodel名.rbを書く？<br>
・スペック -> テストコード(model名_spec.rbなど)のこと<br>
・マッチャ -> 期待する結果とテスト結果が一致するかを判定する(オブジェクト?)
eq, include,..の部分(expectはマッチャではない?) <br>
・puma-> nginx(webサーバー)とrack(アプリケーションサーバー、railsが動いてる場所)を仲介する?<br>
=>localhost:80でアプリ画面が表示されればnginx+pumaでの実行に成功?<br>
・nginx+puma導入参考 https://qiita.com/h4n24w4/items/95347fff33c894d5848a<br>
・puma.sock -> rails sすると自動で作成<br>
=>/var/www/RailsInternApp/tmp/sockets/puma.sockが見つからないエラー -> ディレクトリ/var/www/RailsInternApp/tmp/socketsをmkdirで作成<br>
・プロキシサーバー -> クライアントとサーバーを仲介<br>
・We're sorry, but something went wrongエラー -> /RailsInternApp/log/production.log(development.log)を見る<br>

