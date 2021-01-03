# README

### 事前準備

Usersテーブル作成
```
$ rails generate sorcery:install
```

外部のログイン用のテーブル作成
```
$ rails g sorcery:install external --only-submodules
```

参考: https://github.com/Sorcery/sorcery/wiki/External

### Start Dev

.envファイルを作成して以下を記載
``` bash:.env
LINE_KEY=<LINEログインのチャンネルID>
LINE_SECRET=<LINEログインのチャンネルシークレット>
```

サーバ起動
```
% docker-compose build
% docker-compose run web bundle install
% docker-compose run web db:create
% docker-compose run web db:migrate
% docker-compose up
```
