# 概要
バイクのレビュー投稿アプリです。以下の機能を備えています。

レビューを投稿する(画像投稿機能あり)。  
レビューに「参考になった」を投票する。  
レビューを一覧表示する(ページネーション)。  
レビュー検索する。  
おすすめレビュー動画表示  

## 動作環境
- ruby : 2.5.1
- rails: 5.2.3

## Configuration
Web-application framework : Rails 5  
Front-end component library : Bootstrap 4  
File Uploading : Active Storage  

## データベースの初期化
Webサーバーを起動する前に、db/seeds.rbで初期データを設定します。

## テストスイートの実行方法
モジュールテスト、リクエストテストとシステムテストにはRSpecとcapybaraを使うことができます。

# 本番URL
https://motoprize-prd.herokuapp.com
