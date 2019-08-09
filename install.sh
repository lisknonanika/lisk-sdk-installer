#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
DEFAULT_PROJECT_DIR_NAME="myproject"
PROJECT_DIR=

update_apt () {
  sudo apt update
}

insert_lib () {
  sudo apt install -y python-minimal build-essential curl git
}

setup_postgre () {
  echo "Dockerを使用してPostgreSQLを実行することをおススメします。"
  echo "Dockerを使用する場合はY、使用しない場合はNを入力して下さい。"
  read -p "Dockerを使用しますか？[Y/n] " input
  if [ -z "$input" -o "$input" = "y" -o  "$input" = "Y" ] ; then
    setup_postgre_docker
  else
    setup_postgre_system_wide
  fi
}

setup_postgre_docker () {
  sudo docker stop lisk_sdk_db
  sudo docker rm lisk_sdk_db
  sudo apt-get remove docker docker-engine docker.io containerd runc
  sudo apt-get update
  sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo apt-key fingerprint 0EBFCD88
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io
  sudo apt-get install docker-ce docker-ce-cli containerd.io
  sudo docker run --name lisk_sdk_db -p 5432:5432 -e POSTGRES_USER=lisk -e POSTGRES_PASSWORD=password -e POSTGRES_DB=lisk_dev -d postgres:10
  sudo docker start lisk_sdk_db
  sudo docker exec --tty --interactive lisk_sdk_db psql -h localhost -U lisk -d postgres
}

setup_postgre_system_wide () {
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

read -p "Lisk SDKの実行環境を構築しますか？[y/N]: " input1
if [ "$input1" = "y" -o  "$input1" = "Y" ] ; then
  update_apt
  insert_lib
  setup_postgre
  install_node
  insert_pm2
fi

echo "SDKのプロジェクトのテンプレートを作成することができます。"
echo "実行環境を構築していない場合、動かすことができないのでご注意ください。"
read -p "Lisk SDKのプロジェクトを作成しますか？[y/N]: " input2
if [ "$input2" = "y" -o  "$input2" = "Y" ] ; then
  create_myproject
fi

read -p "Do you want Super Lisk Power?[y/N]: " input3
if [ "$input3" = "y" -o  "$input3" = "Y" ] ; then
  echo "You got power !!!!!!"
  echo ""
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
  echo ""
  echo ""
fi

exit 0
