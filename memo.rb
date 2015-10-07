#Railsの全体的な仕組み
MVC(model-view-controller) というアーキテクチャパターン
model：データベースとの通信を行う
view：与えられた情報を使用してHTMLを表示
controller：ブラウザからのリクエストを受け取って処理する役割

# Railsアプリケーションの作成
$ rails new アプリ名

# Railsプロジェクトへ移動
$ cd アプリ名

# Railsアプリケーションの起動　cloud9では-p以降のオプション指定の必要あり
$ rails s -p $PORT -b $IP
# ※ ローカルで開発を行う場合は[rails s]コマンドで起動が行えます。

# Railsアプリケーションが起動できない場合の対処法
$ sudo service apache2 stop #Apacheの停止をしてから再度起動をやり直す

# アプリの停止
Ctrl + c

# 作業したらGitでコミット　コミットは機能単位、作業単位で必ずする
$ git init #gitの初期化 最初だけ
$ git add .
$ git commit -a -m "first commit"

# GitHubの「Create repository」でリポジトリを作成した後の作業
$ git remote add origin git@github.com:[アカウント名]/[リポジトリ名].git
$ git push -u origin master

# MessagesControllerの作成
$ rails generate controller Messages index
→　iendexアクションも一緒に作成。コントローラとビューの作成が完了。

# routes.rb の設定
root 'messages#index'
# ルートURL(/)にアクセスしたときに作成したコントローラを呼び出す設定。

# 作業したらGitでコミット　コミットは機能単位、作業単位で必ずする
$ git add .
$ git commit -a -m "create messages_controller"

# Modelの作成
$ rails generate model Message name:string body:string

#マイグレーション
データベーススキーマの継続的な変更を、統一的かつ簡単に行なうための便利な手法です。

#SQL
データベースの操作を行うための言語の一つです。アプリケーションからデータベースを操作する場合は、SQL文を発行して操作を行います。

#スキーマ
データベースの構造のことです。スキーマはテーブルとカラムの関連を定義します。

#マイグレート 先ほど作成したモデルをデータベースでも操作できるようにする処理
$ rake db:migrate

#routesの設定 追記（フォームから情報を送信して保存できるようにする）
resources :messages , only: [:create]

#URLヘルパー
routes.rbで設定した値を使うことができる

#erbファイル
HTMLなどの文章の中にRubyスクリプトを埋め込むためのライブラリ
<%= code %>        codeを実行して、結果を文字列として埋め込む
<%  code %>        codeを実行するだけ、結果は埋め込まない
<%# comments %>    コメント

#フォームヘルパー
form_forはRailsが提供するビューヘルパーのひとつ。

<%= form_for(Message.new) do |f| %>
  名前:
  <%= f.text_field :name %>

  内容:
  <%= f.text_field :body %>
  <%= f.submit %>
<% end %>

#ストロングパラメーター
railsのセキュリティ対策の一環で、悪意あるユーザーからの攻撃から守るため
private
    def message_params
    # params[:message]のパラメータで name , bodyのみを許可する。
    # 返り値は ex:) {name: "入力されたname" , body: "入力されたbody" }
    params.require(:message).permit(:name, :body)
end

#バリデーション
オブジェクトがデータベースに保存される前に、そのデータが正しいかどうかを検証する仕組み
class Message < ActiveRecord::Base
    # 名前は必須入力かつ20文字以内
    validates :name , length: {  maximum: 20 } , presence: true
    # 内容は必須入力かつ2文字以上30文字以下
    validates :body , length: {minimum: 2 , maximum: 30 } , presence: true
end

#部分テンプレート（パーシャル）の作成
ファイル名の最初に_を書く