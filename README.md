卒業試験

■サービス概要

楽器の練習記録のサービスです
初心者の頃は演奏を上達させるために、毎日練習しなくてはなりません、自分の演奏している動画を投稿して見返すことで、日々の上達やフォームを確認できます。このような機能があるので、自分の練習時間を管理できます。

■このサービスへの思い・作りたい理由

自分が初心者の頃上達が目に見えないのがかなり苦行でした。
自分で演奏動画を保存していてもやる気がでなかったので、そこでアプリで管理してもらえれば楽かなという思いがありました。
さらに練習が進んでいくと、どの曲を練習したのかを自分でも忘れてしまうのでどこかに保存しておきたい気持ちがありました。そして社会人になって練習時間が取れず、過去に練習した曲も忘れてしまっていたので悩んでいました。

■ユーザー層について

楽器を練習する初心者の方です。

■サービスの利用イメージ

初心者のうちは、毎日練習することが大切です。自分の演奏している姿を見るのはとても大切です。ギターであれば指の動きやフォームが汚いと癖がついてしまい、後々苦労することになります。そして初心者の最大の悩みは上手くなった実感が中々湧きません。そこで毎日動画を取り込むことによって日々の成長を実感し、自分の演奏フォームを確認することによって効率よく上達できます。

■ユーザーの獲得について

SNSで自分のアカウントでの宣伝、SNSで初心者の方で演奏動画を出していない方への声掛け、自分の足で学校の音楽サークルへ声をかけます。

■サービスの差別化ポイント・推しポイント

音楽の学習記録のアプリにはカレンダー機能やメトロノーム機能があります。
差別化を考えている点は
・動画の保存
  マイページ内に自分の練習動画のデータを保存できるリンクを作成し、動画保存ページ内に保存先を指定するボタンを設置する。（練習中の曲ボタン・日課の練習ボタン）

・練習中の曲ページの作成
  動画保存ページで保存した動画の保存先です。
  曲名ごとにフォルダを分けることができる。その曲の練習が完了したら、そのフォルダを練習完了フォルダに移動するボタンを設置して、練習中の曲フォルダから練習完了曲ページ内にフォルダを移動できる。

・練習の終わった曲の管理
  練習中の曲ページからこちらに練習完了曲を移動させることができる。

この三点で背別化を考えております。

■機能候補

・カレンダー機能
  カレンダーの日付をクリックすると詳細ページに飛び、その中に動画の貼り付け、日記を作成できるようにする。

・リマインダー機能
  Line massage APIを使い毎日Lineで「練習したかな？」というメッセージの送信


・練習中の曲の保存
  練習中の曲の演奏動画を撮りここに保存できます。

・完了した練習の保存

練習の完了した曲をここに移動できます。

・コード練習、日課の保存
  曲とは別に毎日やることを設定し「コード練習など」撮影した練習動画を保存する。


以上の機能をMVPリリースまでに作成したいです。



本リリース時には楽曲の練習の場合に動画を投稿したら自動で曲の名前をタイトルに付けられるようにしたいです。

■機能の実現構想

カレンダー機能はsimple_calendarを使い作成しようかと考えております。
リマインダー機能はLINE Messaging APIを使いLINEでメッセージを送れるようにしようと考えております。
動画の保存機能はcarrierwaveを使用しよう考えております。

曲名を表示させる技術はAudDを使用してできないかなと考えております。

■使用予定の技術スタック

・バックエンド
  Ruby on Rails 7.08
  Ruby          3.2.2

・フロントエンド
  Ruby on Rails 7.08

・インフラ
  fly.io

・データベース
  PostgreSQL

以上を今は考えております。


画面遷移図
https://www.figma.com/file/zjtsYiJ0zTxWvKCXcNYNvX/Untitled?type=design&node-id=0%3A1&mode=design&t=f1tmpMOgEf6UFt7z-1

### READMEに記載した機能
- [x] ユーザー登録機能
- [x] ログイン機能
- [x] パスワード変更機能
- [x] メールアドレス変更機能
- [x] カレンダー機能
- [x] カレンダー詳細機能
- [x] カレンダー詳細編集機能
- [X] カレンダー詳細削除機能
- [x] 日記投稿機能
- [x] 練習中の曲一覧機能
- [x] 練習完了曲一覧機能
- [x] 日課一覧機能
- [x] 動画削除機能
- [x] 曲名入力機能

### 未ログインでも閲覧または利用できるページ
以下の項目は適切に未ログインでも閲覧または利用できる画面遷移になっているか？
- [x] TOPページ
- [x] ログイン画面
- [x] 新規登録画面

### メールアドレス・パスワード変更確認項目
直接変更できるものではなく、一旦メールなどを介して専用のページで変更する画面遷移になっているか？
- [x] メールアドレス
- [x] パスワード

ER図
[text](er.drawio)

テーブル・カラムの説明
- userテーブル: userの情報を持つテーブル
  - name: ユーザーネーム
  - email: メールアドレス
  - crypted_password: パスワード
  - salt: sorcery
  - line_id: ラインのユーザー識別

- Diarysテーブル: 日記の情報を持つテーブル
  - content: コメント
  - status: 状態（練習中・練習完了・日課）
  - date: 日記の日付

- Videosテーブル: 動画の情報を持つテーブル
  - file_path: 動画ファイルのパス
  - uploaded_at: 動画のアップロード日
  - title: タイトル
  - artist: アーティスト名

- Remaindersテーブル: リマインダーの情報を持つテーブル
  - message: リマインダーメッセージ
  - remind_at: 送信日
  - status: 状態（送信予定・送信済み）

- Tasksテーブル：タスクの情報を持つテーブル
 - task_date: タスクの対象日
 