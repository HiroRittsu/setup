#!/bin/bash
#作製　みぐりー

#ホームディレクトリ
homedir=/home/$USER

echo
echo "レスキューシミュレーション用環境構築スクリプト"
echo
echo "入力は慎重に..."
echo
echo
echo "GoogleChromeをインストールしますか?(y/n)"
read goolgechorome
echo "Slackをインストールしますか?(y/n)"
read slack
echo "VisualStudioCodeをインストールしますか?(y/n)"
read vscode
echo "Atomをインストールしますか?(y/n)"
read atom
echo "SublimeText3をインストールしますか?(y/n)"
read sublime
echo "RioneLauncherをインストールしますか?(y/n)"
read rionelauncher
echo "RioneViewerをインストールしますか?(y/n)"
read rioneviewer

clear
echo
echo "GoogleChrome: "$goolgechorome
echo "Slack: "$slack
echo "VisualStudioCode: "$vscode
echo "Atom: "$atom
echo "SublimeText3: "$sublime
echo "RioneLauncher: "$rionelauncher
echo "RioneViewer: "$rioneviewer
echo
echo "これで大丈夫ですか？(y/n)"
read ok

if [ $ok = 'y' ]; then

	sudo killall -KILL apt.systemd.daily
	sudo mv /etc/apt/apt.conf.d/50appstream /etc/apt/apt.conf.d/50appstream.disable
	sudo apt update -y
	sudo apt upgrade -y
	sudo mv /etc/apt/apt.conf.d/50appstream.disable /etc/apt/apt.conf.d/50appstream
	sudo apt update -y

#goolgechorome
if [ $goolgechorome = 'y' ]; then
	
	echo
	echo "ブラウザから.debをダウンロードしてください。場所は変更しなくても大丈夫です。"
	echo
	firefox https://www.google.com/chrome/browser/desktop/index.html?brand=CHBD&ds_kid=43700010867180244&gclid=EAIaIQobChMI792Bq5OG2AIVlgoqCh1K9AqbEAAYASAAEgLrVvD_BwE&gclsrc=aw.ds&dclid=CN7v8quThtgCFcM4lgodb3IPbA
	echo
	echo "完了したら何か入力してください。"
	read wait
	cd $homedir/ダウンロード/
	sudo apt-get install libnss3
	sudo dpkg -i google-chrome-stable_current_amd64.deb
	cd
	
fi

#スラック
if [ $slack = 'y' ]; then
	
	wget https://downloads.slack-edge.com/linux_releases/slack-desktop-2.9.0-amd64.deb
	mv slack-desktop-2.9.0-amd64.deb $homedir/ダウンロード/
	cd $homedir/ダウンロード/
	sudo dpkg -i slack-desktop-2.9.0-amd64.deb
	cd
	
fi

#VScode
if [ $vscode = 'y' ]; then
	
	echo
	echo "ブラウザから.debをダウンロードしてください。場所は変更しなくても大丈夫です。"
	echo
	firefox https://code.visualstudio.com/
	echo
	echo "完了したら何か入力してください。"
	read wait
	cd $homedir/ダウンロード/
	sudo dpkg -i code_1.18.1-1510857349_amd64.deb
	cd
	
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
	cd $homedir/ダウンロード/
	sudo dpkg -i atom-amd64.deb
	cd
	
fi

#sublime 
if [ $sublime= 'y' ]; then

	$homedir/ダウンロード/
	wget https://download.sublimetext.com/sublime_text_3_build_3176_x64.tar.bz2
	tar -xf sublime_text_3_build_3176_x64.tar.bz2 -C $homedir
	
fi

#javaインストール
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get -f install
sudo apt-get install oracle-java8-installer

#eclipceインストール
echo
echo "ブラウザから.debをダウンロードしてください。場所は変更しなくても大丈夫です。"
echo
cd $homedir/ダウンロード/
wget http://ftp.jaist.ac.jp/pub/eclipse/oomph/epp/oxygen/R/eclipse-inst-linux64.tar.gz
tar -zxvf eclipse-inst-linux64.tar.gz
cd eclipse-installer 
./eclipse-inst
cd

#eclipse日本語化
wget http://ftp.jaist.ac.jp/pub/mergedoc/pleiades/build/stable/pleiades.zip
mv pleiades.zip $homedir/ダウンロード/
cd $homedir/ダウンロード/
unzip pleiades.zip -d $homedir/eclipse/java-oxygen/eclipse/
echo -Xverify:none >> $homedir/eclipse/java-oxygen/eclipse/eclipse.ini
echo -javaagent:$homedir/eclipse/java-oxygen/eclipse/plugins/jp.sourceforge.mergedoc.pleiades/pleiades.jar >> $homedir/eclipse/java-oxygen/eclipse/eclipse.ini
sudo ln -s $homedir/eclipse/java-oxygen/eclipse/eclipse /usr/bin
cd

#Eclipse_Icon適応
if [ `cat /etc/os-release | grep -c 16.04` -ne 0 ]; then

	cd ~/.local/share/applications/
	
	rm eclipse.desktop &>/dev/null
	touch eclipse.desktop
	
	echo "[Desktop Entry]" >> eclipse.desktop
	echo "Type=Application" >> eclipse.desktop
	echo "Name=Eclipse" >> eclipse.desktop
	echo "GenericName=IDE" >> eclipse.desktop
	echo "Icon=/home/$USER/eclipse/java-oxygen/eclipse/icon.xpm" >> eclipse.desktop
	echo "Exec=/home/$USER/eclipse/java-oxygen/eclipse/eclipse" >> eclipse.desktop
	echo "Terminal=false" >> eclipse.desktop
	echo "Name[ja]=Eclipse" >> eclipse.desktop
	
fi

#gitディレクトリ作成
mkdir $homedir/git

#gitインストール
sudo apt-get install git

#サーバー
echo "サーバーは私のwikiの「レスキューサンプル＆サーバー最新バージョン導入について...」を参考に導入してください。"
firefox http://rione.org/protected/index.php?Member%2F14%E6%9C%9F%E7%94%9F%2F%E9%87%8E%E5%B4%8E%E5%BC%98%E6%99%83%2F%E9%96%8B%E7%99%BA%E6%97%A5%E8%AA%8C

#ソースコード
cd $homedir/git
wget -nd https://github.com/RCRS-ADF/RCRS-ADF/releases/download/release/adf-sample.tar.gz
tar -zxvf adf-sample.tar.gz
mv adf-sample sample
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

fi

echo
echo
echo "環境構築は終了しました"


exit 1
