#!/bin/bash
#作製　みぐりー

#ホームディレクトリ
homedir="/home/$USER"

echo
echo "Ubuntu環境構築スクリプト"
echo
echo
echo "GoogleChromeをインストールしますか?(y/n)"
read goolgechorome
echo "Slackをインストールしますか?(y/n)"
read slack
echo "VisualStudioCodeをインストールしますか?(y/n)"
read vscode
echo "Vimをインストールしますか？(y/n)"
read vim
echo "Emacsをインストールしますか？(y/n)"
read emacs
echo "Atomをインストールしますか?(y/n)"
read atom
echo "SublimeText3をインストールしますか?(y/n)"
read sublime
echo "Eclipseをインストールしますか?(y/n)"
read eclipse
echo "Pycharmをインストールしますか？(y/n)"
read pycharm
echo "IntelliJをインストールしますか？(y/n)"
read intellij

clear
echo
echo "GoogleChrome: "$goolgechorome
echo "Slack: "$slack
echo "VisualStudioCode: "$vscode
echo "Vim: "$vim
echo "Emacs: "$emacs
echo "Atom: "$atom
echo "SublimeText3: "$sublime
echo "Eclipse: "$eclipse
echo "Pycharm: "$pycharm
echo "IntelliJ: "$intellij

echo
echo "これで大丈夫ですか？(y/n)"
read ok

if [ $ok = 'y' ]; then

	#ディレクトリ英語化
	cd .config
	sed -i s/'デスクトップ'/'Desktop'/g user-dirs.dirs
	sed -i s/'ダウンロード'/'Downloads'/g user-dirs.dirs
	sed -i s/'テンプレート'/'Temp'/g user-dirs.dirs
	sed -i s/'公開'/'Public'/g user-dirs.dirs
	sed -i s/'ドキュメント'/'Documents'/g user-dirs.dirs
	sed -i s/'ミュージック'/'Music'/g user-dirs.dirs
	sed -i s/'ピクチャ'/'Pictures'/g user-dirs.dirs
	sed -i s/'ビデオ'/'Videos'/g user-dirs.dirs
	cd ~/
	mv $HOME/デスクトップ $HOME/Desktop
	mv $HOME/ダウンロード $HOME/Downloads
	mv $HOME/テンプレート $HOME/Temp
	mv $HOME/公開 $HOME/Public
	mv $HOME/ドキュメント $HOME/Documents
	mv $HOME/ミュージック $HOME/Music
	mv $HOME/ピクチャ $HOME/Pictures
	mv $HOME/ビデオ $HOME/Videos

	#初期エラー対処
	sudo killall -KILL apt.systemd.daily
	sudo mv /etc/apt/apt.conf.d/50appstream /etc/apt/apt.conf.d/50appstream.disable
	sudo apt update -y
	sudo apt upgrade -y
	sudo mv /etc/apt/apt.conf.d/50appstream.disable /etc/apt/apt.conf.d/50appstream
	sudo apt update -y
	sudo timedatectl set-local-rtc true
	sudo apt-get -f intsall
	
	sudo apt install git #git

	#goolgechorome
	if [ $goolgechorome = 'y' ]; then

		echo
		#echo "ブラウザから.debをダウンロードしてください。場所は変更しなくても大丈夫です。"
		echo
		#firefox https://www.google.com/chrome/browser/desktop/index.html?brand=CHBD&ds_kid=43700010867180244&gclid=EAIaIQobChMI792Bq5OG2AIVlgoqCh1K9AqbEAAYASAAEgLrVvD_BwE&gclsrc=aw.ds&dclid=CN7v8quThtgCFcM4lgodb3IPbA
		echo
		#echo "完了したら何か入力してください。"
		#read wait
		cd ~/Downloads/
		wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
		sudo apt-get install libnss3
		sudo dpkg -i google-chrome-stable_current_amd64.deb
		cd

	fi

	#スラック
	if [ $slack = 'y' ]; then
		
		wget https://downloads.slack-edge.com/linux_releases/slack-desktop-2.9.0-amd64.deb
		mv slack-desktop-2.9.0-amd64.deb ~/Downloads/
		cd ~/Downloads/
		sudo apt-get install libappindicator1
		sudo dpkg -i slack-desktop-2.9.0-amd64.deb
		cd
		
	fi

	#VScode
	if [ $vscode = 'y' ]; then

		cd ~/Downloads/
		wget https://go.microsoft.com/fwlink/?LinkID=760868
		sudo dpkg -i `ls | grep "LinkID"`
		cd
		
	fi
	
	#vim
	if [ $vim = 'y' ]; then

		sudo apt install vim
		
	fi 
	
	#emacs
	if [ $emacs = 'y' ]; then

		sudo apt install emacs ibus-mozc emacs-mozc
		
	fi 
	

	#atom
	if [ $atom = 'y' ]; then
		
		echo
		echo "ブラウザから.debをダウンロードしてください。場所は変更しなくても大丈夫です。"
		echo
		firefox https://atom.io/
		echo
		echo "完了したら何か入力してください。"
		read wait
		cd ~/Downloads/
		sudo dpkg -i atom-amd64.deb
		cd
		
	fi

	#sublime 
	if [ $sublime = 'y' ]; then

		wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
		sudo apt-get install apt-transport-https
		echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
		sudo apt-get update
		sudo apt-get install sublime-text
		
	fi

	#eclipse
	if [ $eclipse = 'y' ]; then
		#java
		sudo add-apt-repository ppa:webupd8team/java
		sudo apt-get update
		sudo apt-get -f install
		sudo apt-get install oracle-java8-installer

		#eclipceインストール
		cd ~/Downloads/
		wget http://ftp.jaist.ac.jp/pub/eclipse/oomph/epp/oxygen/R/eclipse-inst-linux64.tar.gz
		tar -zxvf eclipse-inst-linux64.tar.gz
		cd eclipse-installer 
		./eclipse-inst
		cd
		
		ECLIPSE=`find ~/ -name "eclipse.ini" | sed 's@/eclipse.ini@@g'`

		#eclipse日本語化
		wget http://ftp.jaist.ac.jp/pub/mergedoc/pleiades/build/stable/pleiades.zip
		mv pleiades.zip ~/Downloads/
		cd ~/Downloads/
		unzip pleiades.zip -d $ECLIPSE
		echo -Xverify:none >> $ECLIPSE/eclipse.ini
		echo -javaagent:$ECLIPSE/plugins/jp.sourceforge.mergedoc.pleiades/pleiades.jar >> $ECLIPSE/eclipse.ini
		sudo ln -s $ECLIPSE/eclipse /usr/bin
		cd

		#eclipse_Icon適応
		if [ `cat /etc/os-release | grep -c 16.04` -ne 0 ]; then

			cd ~/.local/share/applications/
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
		
	fi
	
	#pycharm 
	if [ $pycharm = 'y' ]; then

		cd ~/Downloads/ 
		wget https://download.jetbrains.com/python/pycharm-community-2018.3.2.tar.gz
		tar -zxvf pycharm-community-2018.3.2.tar.gz
		mv pycharm-community-2018.3.2 ~/pycharm
		
		PYCHARM=`find ~/ -type d -name ".*" -prune -o -type f -print | grep "pycharm.sh" | sed 's@/bin/pycharm.sh@@g'`

		wget http://ftp.jaist.ac.jp/pub/mergedoc/pleiades/build/stable/pleiades.zip
		unzip pleiades.zip -d $PYCHARM
		echo -Xverify:none >> $PYCHARM/bin/pycharm64.vmoptions
		echo -javaagent:$PYCHARM/plugins/jp.sourceforge.mergedoc.pleiades/pleiades.jar >> $PYCHARM/bin/pycharm64.vmoptions
		echo -Xverify:none >> $PYCHARM/bin/pycharm.vmoptions
		echo -javaagent:$PYCHARM/plugins/jp.sourceforge.mergedoc.pleiades/pleiades.jar >> $PYCHARM/bin/pycharm.vmoptions
		
	fi
	
	#intellij 
	if [ $intellij = 'y' ]; then

		cd ~/Downloads/ 
		wget https://download.jetbrains.com/idea/ideaIC-2018.3.5.tar.gz
		tar -zxvf ideaIC-2018.3.5.tar.gz
		mv ideaIC-2018.3.5.tar.gz ~/intellij
		
		INTELLIJ=`find ~/ -type d -name ".*" -prune -o -type f -print | grep "idea.sh" | sed 's@/bin/idea.sh@@g'`

		wget http://ftp.jaist.ac.jp/pub/mergedoc/pleiades/build/stable/pleiades.zip
		unzip pleiades.zip -d $INTELLIJ
		echo -Xverify:none >> $INTELLIJ/bin/idea64.vmoptions
		echo -javaagent:$INTELLIJ/plugins/jp.sourceforge.mergedoc.pleiades/pleiades.jar >> $INTELLIJ/bin/idea64.vmoptions
		echo -Xverify:none >> $INTELLIJ/bin/idea.vmoptions
		echo -javaagent:$INTELLIJ/plugins/jp.sourceforge.mergedoc.pleiades/pleiades.jar >> $INTELLIJ/bin/idea.vmoptions
		
	fi
	
	
	

	

	echo
	echo
	echo "環境構築が完了しました。"

fi

exit 1
