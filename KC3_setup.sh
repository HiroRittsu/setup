#!/bin/bash
#作製　みぐりー

#ホームディレクトリ
HOMEDIR="/home/$USER"
RESCUEDIR="/home/$USER/KC3rescue"

echo
echo "KC3用環境構築スクリプト"
echo
echo "Eclipseをインストールしますか?(y/n)"
read eclipse

echo

if [[ $eclipse = 'y' ]]; then
	echo ' ▶ Eclipseをインストールします。'
else
	echo ' ▶ Eclipseはインストールされません。'
fi
echo


echo 'これでよろしいですか？(y/n）'
read ok

if [[ $ok = 'y' ]]; then

	#java
	echo ' ▶ oracle-java8をインストールします。'
	sudo add-apt-repository ppa:webupd8team/java
	sudo apt update
	sudo apt -f install
	sudo apt install oracle-java8-installer
	
	if [[ $eclipse = 'y' ]]; then

		mkdir $HOMEDIR/KC3Downloads

		echo ' ▶ Eclipceをインストールします。'

		#eclipceインストール
		cd $HOMEDIR/KC3Downloads/
		wget http://ftp.jaist.ac.jp/pub/eclipse/oomph/epp/oxygen/R/eclipse-inst-linux64.tar.gz
		tar -zxvf eclipse-inst-linux64.tar.gz
		cd eclipse-installer 
		./eclipse-inst
		cd $HOMEDIR
		
		ECLIPSE=$(find $HOMEDIR/ -name "eclipse.ini" | sed 's@/eclipse.ini@@g')

		#eclipse日本語化
		wget http://ftp.jaist.ac.jp/pub/mergedoc/pleiades/build/stable/pleiades.zip
		mv pleiades.zip $HOMEDIR/KC3Downloads/
		cd $HOMEDIR/KC3Downloads/
		unzip pleiades.zip -d $ECLIPSE
		echo -Xverify:none >> $ECLIPSE/eclipse.ini
		echo -javaagent:$ECLIPSE/plugins/jp.sourceforge.mergedoc.pleiades/pleiades.jar >> $ECLIPSE/eclipse.ini
		sudo ln -s $ECLIPSE/eclipse /usr/bin
		cd $HOMEDIR

		#eclipse_Icon適応
		if [[ $(cat /etc/os-release | grep -c 16.04) -ne 0 ]]; then

			cd $HOMEDIR/.local/share/applications/
			rm eclipse.desktop &>/dev/null
			touch eclipse.desktop
			echo "[Desktop Entry]" >> eclipse.desktop
			echo "Type=Application" >> eclipse.desktop
			echo "Name=Eclipse" >> eclipse.desktop
			echo "GenericName=IDE" >> eclipse.desktop
			echo "Icon=$ECLIPSE/icon.xpm" >> eclipse.desktop
			echo "Exec=$ECLIPSE/eclipse" >> eclipse.desktop
			echo "Terminal=false" >> eclipse.desktop
			echo "Name[ja]=Eclipse" >> eclipse.desktop
			
		fi

		rm -rf $HOMEDIR/KC3Downloads
		
	fi

	echo 'レスキュー環境を構築します'
	mkdir $RESCUEDIR

	#antインストール
	sudo apt install ant

	#gitインストール
	sudo apt install git

	#サーバー
	cd $RESCUEDIR
	git clone https://github.com/roborescue/rcrs-server.git
	cd ./rcrs-server
	ant clean-all
	ant complete-build
	cd $HOMEDIR

	#新ソースコード
	cd $RESCUEDIR
	git clone https://github.com/Ri--one/KC3agent.git

	#RioneLauncherダウンロード
	wget -O RioneLauncher.sh https://raw.githubusercontent.com/Ri--one/bash-rescue/master/RioneLauncher.sh

	cd $HOMEDIR

	echo '環境構築が終了しました。'

fi
