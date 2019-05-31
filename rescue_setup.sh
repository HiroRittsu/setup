#!/bin/bash
#作製　みぐりー

echo "RioneLauncherをインストールしますか?(y/n)"
read rionelauncher

clear
echo "RioneLauncher: "$rionelauncher
echo
echo "これで大丈夫ですか？(y/n)"
read ok

if [ $ok = 'y' ];then
	
	#javaインストール
	sudo apt-get update
	sudo apt-get -f install
	sudo apt install openjdk-8-jdk

	#gitディレクトリ作成
	mkdir ~/git

	#gitインストール
	sudo apt install git
	
	#antインストール
	sudo apt install ant
	
	#旧サーバー
	cd ~/git
	wget -O install-roborescue.sh https://raw.githubusercontent.com/tkmnet/rcrs-scripts/master/install-roborescue.sh
	sed -i -e '32,34d' install-roborescue.sh 
	sed -i -e "32i \$WGET https://sourceforge.net/projects/roborescue/files/roborescue/v1.2/roborescue-v1.2.tgz" install-roborescue.sh
	sed -i -e "33i tar zxvf ./roborescue-v1.2.tgz" install-roborescue.sh
	sed -i -e "34i rm ./roborescue-v1.2.tgz" install-roborescue.sh
	bash install-roborescue.sh
	rm install-roborescue.sh
	rm -rf apache-ant*
	cd roborescue-v1.2
	ant
	
	#新サーバー
	sudo apt install gradle
	cd ~/git
	git clone https://github.com/roborescue/rcrs-server.git
	cd rcrs-server
	sed -i 's@implementation@compile@g' build.gradle
	sed -i 's@testImplementation@compile@g' build.gradle
	gradle clean
	gradle completeBuild
	cd

	#新ソースコード
	cd ~/git
	git clone https://github.com/roborescue/rcrs-adf-sample.git
	cd
	
	cd ~/git
	git clone https://bitbucket.org/rione/rionerescue.git
	cd

	#RioneLauncherダウンロード
	if [ $rionelauncher = 'y' ]; then

		wget -O RioneLauncher.sh https://raw.githubusercontent.com/Ri--one/bash-rescue/master/RioneLauncher.sh
		mv RioneLauncher.sh ~/git/RioneLauncher.sh

	fi

	echo
	echo
	echo "環境構築は終了しました"
	
fi

exit 1
