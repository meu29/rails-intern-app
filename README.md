railsで勤怠管理アプリを作る

##やること・メモ
・intern_db.dumpをsqlにインポート <br>
 sudo mysql -u newuser -p import先データベース名 < '/home/meu/ドキュメント/RailsInternApp/intern_db.dump' <br>
・sudo apt install redis-cli でredisをインストール<br>
・データベースは本番用(InternAppDatabase)とテスト用(InternAppDatabase_test)の2種類<br>
・テスト駆動開発 -> 先にmodel名_spec.rbを書く => これに受かるようにmodel名.rbを書く？<br>
・スペック -> テストコード(model名_spec.rbなど)のこと<br>
・マッチャ -> 期待する結果とテスト結果が一致するかを判定する(オブジェクト?)
eq, include,..の部分(expectはマッチャではない?) <br>
・nginx導入参考 https://qiita.com/corona6@github/items/cfac19432532d261912d<br>
起動しなければ<br>
access_log      /var/www/test/logs/access.log;<br>
error_log       /var/www/test/logs/error.log;<br>
の部分を消す<br>
・Unicorn -> nginx(webサーバー)とrack(アプリケーションサーバー、railsが動いてる場所)を仲介する?
・Unicorn終了時 -> kill -QUIT 6612
