#!/bin/bash
#作製　みぐりー

echo "RioneLauncherをインストールしますか?(y/n)"
read rionelauncher
echo "ねねっちをインストールしますか?(y/n)"
read rioneviewer

clear
echo "RioneLauncher: "$rionelauncher
echo "RioneViewer: "$rioneviewer
echo
echo "これで大丈夫ですか？(y/n)"
read ok

if [ $ok = 'y' ];then
	
	#javaインストール
	sudo add-apt-repository ppa:webupd8team/java
	sudo apt-get update
	sudo apt-get -f install
	sudo apt-get install oracle-java8-installer

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
	cd ~/git
	git clone https://github.com/roborescue/rcrs-server.git
	cd rcrs-server
	ant clean-all
	ant complete-build
	cd

	#新ソースコード
	cd ~/git
	git clone https://github.com/roborescue/rcrs-adf-sample.git
	cd

	#RioneLauncherダウンロード
	if [ $rionelauncher = 'y' ]; then

		wget -O RioneLauncher.sh https://raw.githubusercontent.com/MiglyA/bash-rescue/master/RioneLauncher.sh
		mv RioneLauncher.sh ~/git/RioneLauncher.sh

	fi

	#ねねっちビューアーインストール
	if [ $rioneviewer = 'y' ]; then

		echo
		echo "GoogleDriveのInsdtaller.zipをダウンロードしてください。場所は変更しなくても大丈夫です。"
		echo
		firefox https://drive.google.com/drive/folders/0B1BfWs2E1JvbbFpvWGtjTGxDeVU
		echo
		echo "完了したら何か入力してください。"
		read wait
		unzip Installer.zip
		bash Installer.sh

	fi

	echo
	echo
	echo "環境構築は終了しました"
	
fi

exit 1
