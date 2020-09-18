railsで勤怠管理アプリを作る

##やること・メモ
・intern_db.dumpをsqlにインポート(参考: https://qiita.com/rato303/items/2e614f23e5feee150ffc) <br>
・sudo apt install redis-cli でredisをインストール<br>
・データベースは本番用(InternAppDatabase)とテスト用(InternAppDatabase_test)の2種類<br>
・テスト駆動開発 -> 先にmodel名_spec.rbを書く => これに受かるようにmodel名.rbを書く？<br>
・スペック -> テストコード(model名_spec.rbなど)のこと
