# lisk-sdk-installer
## 概要
Ubuntu上にLisk SDKのプロジェクト作成するための環境を構築するshellです。
<br><br>
#### 使用すると、以下が行われます。
- 必要なライブラリの導入 (Python, Curl, Git など)
- Node.js 12.15.0 のインストール
- PostgreSQL 10 のインストール
  - 構築されるDBは以下の通り
    - DB名： lisk_dev
    - ユーザー名： lisk
    - パスワード： password
    - Docker： lisk_sdk_db ※環境構築時にPostgreSQLをDockerで動かすようにした場合
  
- PM2 のインストール
- プロジェクトのテンプレート作成 (npm install & lisk-sdkの導入 & 動作確認用のindex.js の追加)
  - プロジェクトは $HOME/lisk-dev/ の下に作成されます。
<br><br>
## 使い方
UbuntuにLisk SDKのプロジェクトを作成したいユーザーでログイン後、端末で install.sh を実行して下さい。(以下、例)
<br>
`
bash lisk-sdk-installer/install.sh
`
<br><br>
※環境構築とプロジェクト作成は分けて実行できます。(実行前に Yes or No が聞かれます)
<br>
※はじめは両方とも実行してください。
<br><br>
プロジェクトが作成されたら、以下を端末で実行して下さい。
<br>
`cd ~/lisk_dev/<作成時につけたプロジェクト名>`
<br>
`node index.js | npx bunyan -o short`
<br>
または
<br>
`pm2 start index.js`
<br><br>
上記を実行後
http:localhost:4000/api/transactions
などで実行されているか確認できます。

## 注意
別の何かで使用している環境に導入した場合、依存関係等の変更により動かなくなっても責任とりません。
<br>
出来る限りLisk SDK専用のUbuntuで実行することをお勧めします。
<br><br>
以上
