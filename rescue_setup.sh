#!/bin/bash
#作製　みぐりー

#ホームディレクトリ
homedir="/home/$USER"

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
	mkdir $homedir/git

	#gitインストール
	sudo apt install git

	#新サーバー
	cd $homedir/git
	git clone https://github.com/roborescue/rcrs-server.git
	sudo apt install ant
	cd rcrs-server
	ant clean-all
	ant complete-build
	cd

	#ソースコード
	cd $homedir/git
	git clone https://github.com/roborescue/rcrs-adf-sample.git
	cd

	#RioneLauncherダウンロード
	if [ $rionelauncher = 'y' ]; then

		wget -O RioneLauncher.sh https://raw.githubusercontent.com/MiglyA/bash-rescue/master/RioneLauncher3.00.sh
		mv RioneLauncher.sh $homedir/git/RioneLauncher.sh

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
