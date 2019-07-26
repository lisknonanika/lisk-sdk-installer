# lisk-sdk-installer
## 概要
Ubuntu上にLisk SDKのプロジェクト作成するための環境を構築するshellです。
<br><br>
#### 使用すると、以下が行われます。
- 必要なライブラリの導入 (Python, Curl, Git など)
- Node.js 10.15.3 のインストール
- PostgreSQL 10 のインストール
  - 構築されるDBは以下の通り
    - DB名： lisk_dev
    - ユーザー名： lisk
    - パスワード： password
  
- PM2 のインストール
- プロジェクトのテンプレート作成 (npm install & lisk-sdkの導入 & 動作確認用のindex.js の追加)
  - プロジェクトは $HOME/lisk-dev/ の下に作成されます。
<br><br>
## 使い方
UbuntuにLisk SDKのプロジェクトを作成したいユーザーでログイン後、端末で install.sh を実行して下さい。(以下、例)
<br>
`
sh lisk-sdk-installer/install.sh
`
<br><br>
※環境構築とプロジェクト作成は分けて実行できます。(実行前に Yes or No が聞かれます)
<br>
※はじめは両方とも実行してください。
<br><br>
プロジェクトが作成されたら、以下を端末で実行して下さい。
<br>
`
cd ~/lisk-dev/<作成時につけたプロジェクト名>
node index.js will start the node, and | npx bunyan -o short 
`
<br><br>
## 注意
別の何かで使用している環境に導入した場合、依存関係等の変更により動かなくなっても責任とりません。
<br>
出来る限りLisk SDK専用のUbuntuで実行することをお勧めします。
<br><br>
以上
