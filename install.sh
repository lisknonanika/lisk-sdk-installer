#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
DEFAULT_PROJECT_DIR_NAME="myproject"
PROJECT_DIR=

update_apt () {
  sudo apt update
}

insert_lib () {
  sudo apt install -y python build-essential curl automake autoconf libtool ntp git
}

install_node () {
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
  . ~/.nvm/nvm.sh
  . ~/.profile
  . ~/.bashrc
  export NVM_DIR="$HOME/.nvm"
  nvm install 10.15.3
}

insert_pm2 () {
  npm install pm2 -g
}

setup_postgre () {
  sudo apt-get purge -y postgres* # remove all already installed postgres versions
  sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
  sudo apt install wget ca-certificates
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
  sudo apt update
  sudo apt install postgresql-10
  pg_lsclusters
  sudo pg_dropcluster --stop 10 main
  sudo pg_createcluster --locale en_US.UTF-8 --start 10 main
  sudo -u postgres createuser --createdb lisk
  sudo -u postgres -i createdb lisk_dev --owner lisk
  sudo -u postgres psql -d lisk_dev -c "alter user lisk with password 'password';"
}

create_myproject () {
  echo "Lisk SDKを使う、あなたのプロジェクト名を入力して下さい。"
  echo "note: プロジェクトのフォルダは ~/lisk-dev/ の下に作成されます。"
  echo "note: 未設定の場合は myproject という名前で作成されます。"
  read -p "プロジェクト名: " proj
  
  if [ -z $proj ] ; then
    PROJECT_DIR=~/lisk_dev/$DEFAULT_PROJECT_DIR_NAME
  else
    PROJECT_DIR=~/lisk_dev/$proj
  fi
  mkdir -p $PROJECT_DIR
  cd $PROJECT_DIR
  npm init
  npm install lisk-sdk
  cp $SCRIPT_DIR/index.js $PROJECT_DIR/index.js
}

echo "Lisk SDKの実行環境を構築しますか？[y/N]"
read -p "Y or N: " input1

if [ "$input1" = "y" -o  "$input1" = "Y" ] ; then
  update_apt
  insert_lib
  install_node
  insert_pm2
  setup_postgre
fi

echo "Lisk SDKのプロジェクトを作成しますか？[y/N]"
echo "note: 実行環境を構築していない場合、動かすことができないのでご注意ください。"
read -p "Y or N: " input2
if [ "$input2" = "y" -o  "$input2" = "Y" ] ; then
  create_myproject
fi

echo "Do you want Super Lisk Power?[y/N]"
read -p "Y or N: " input3
if [ "$input3" = "y" -o  "$input3" = "Y" ] ; then
  echo "You got power !!!!!!"
  echo "                                     .,"
  echo "                                    .MMe"
  echo "                                   .MMMMp"
  echo "                                   ?MMMMMb"
  echo "                                 .h -MMMMMh"
  echo "                                JMMN.,MMMMMN."
  echo "                               dMMMMN .MMMMMN,                 .g                                  .g"
  echo "                             .MMMMMM'  .MMMMMN,               .M#                                 (M#"
  echo "                            .MMMMM#      WMMMMM,            .MMM#                               .MMM#"
  echo "                           .MMMMM@        UMMMMMe          .MMMM#             .<   .+MMMMNa,   .MMMM#   .NNNNN^"
  echo "                          .MMMMMD          TMMMMMp         .MMMM#           .dM)  dMMMMMMMMMN, .MMMM#  JMMMM#!"
  echo "                         .MMMMMF            ?MMMMMb        .MMMM#          .MMM) .MMMMF .T9^   .MMMM#.dMMMMD"
  echo "                        .MMMMMD              (MMMMMh       .MMMM#         MMMMM) .MMMMMMNNg,   .MMMMNMMMMMD"
  echo "                       .WMMMMMN,            .dMMMMM#'      .MMMM#         MMMMM)   TMMMMMMMMMe .MMMMMMMMMN."
  echo "                         (MMMMMMh.        .JMMMMMM3        .MMMMN........ MMMMM)   .., _TMMMMM .MMMM#(MMMMN,"
  echo "                           7MMMMMMagggg! .MMMMMMD          .MMMMMMMMMMMM} MMMMM) +MMMMNNMMMMM# .MMMM# .MMMMMp"
  echo "                             TMMMMMMMD .MMMMMMB!           .MMMMMMMMMMMM} MMMMM)  TMMMMMMMMMD  .MMMM#   UMMMMN."
  echo "                              ,MMMMB!.JMMMMMM^"
  echo ""
fi

exit 0
