#!/bin/bash
#製作者: みぐりー
#
#
#soccerフォルダの場所
soccer_address="/home/$USER/soccer"
#
#使用するチームをフルパスで指定してください。
#固定したくない場合は空白で大丈夫です。
 #例) team_1=/home/$USER/soccer/agent2d-3.1.1/src
team[0]=/home/$USER/soccer/agent2d-3.1.1/src
team[1]= #/home/$USER/soccer/agent2d-3.1.1/src
#
#倍速を有効にするか指定してください。
#固定したくない場合は空白で大丈夫です。
 #例) synch_mode=false
synch_mode= #true
#
#/////////////////////////////////////////////////////////////
#ここから先は改変しないでくだせぇ動作が止まっても知らないゾ？↓

#自動アップデート
CurrentVer=1.00
echo
echo "Ver.$CurrentVer"
echo
echo "バージョンチェックを行います。"
echo "※ 少し時間がかかる場合があります。"
echo


	if [ ! `curl --connect-timeout 3 https://raw.githubusercontent.com/MiglyA/bash_soccer/master/histry.txt | grep "SoccerLauncher-newVersion" | awk '{print $2}'` = $CurrentVer ]; then &>/dev/null

		echo "自動アップデートを行います"
		#wget -N -O RioneLauncher.sh `curl https://raw.githubusercontent.com/MiglyA/bash_soccer/master/histry.txt | grep "SoccerLauncher-link" | awk '{print $2}'` &>/dev/null

		IFS=$'\n'

		t=(`cat $0 | head -$(grep -n '？↓' test1.sh | sed 's/:/ /g' | sed -n 1P | awk '{print $1}')`)

		filename=$0

		rm $filename

		echo "${t[*]}" > $filename

		curl `curl https://raw.githubusercontent.com/MiglyA/bash_soccer/master/histry.txt | grep "SoccerLauncher-link" | awk '{print $2}'` >> $0


		echo
		echo "アップデート完了しました。"
		echo "再起動をおねがいします。"
		echo
		exit 1

	fi

#soccerフォルダの有無を確認。
if [ ! -e $soccer_address ] || [ -z $soccer_address ]; then

	echo
	echo "soccerフォルダがありません。出直してきてください。"
	echo
	exit 1

fi

#環境変数変更
IFS=$'\n'

cd $soccer_address

find . -name "* *" | rename 's/ /_/g'

cd

#チームディレクトリ登録
if [ -z ${team[0]} ] || [ -z ${team[1]} ] || [ ! -f ${team[0]}/start.sh ] || [ ! -f ${team[1]}/start.sh ]; then

	#ディレクトリ取得
	teamdirinfo=(`find $soccer_address -name start.sh | sed 's@/start.sh@@g'`)

	if [ ${#teamdirinfo[@]} -eq 0 ]; then

		echo
		echo "チームが見つかりません…ｷｮﾛ^(･д･｡)(｡･д･)^ｷｮﾛ"
		echo
		exit 1

	fi

	#チーム名+ディレクトリ情報登録
	count=0
	for i in ${teamdirinfo[@]}; do

		name=`grep "teamname=" $i/start.sh | sed -n 1P | sed 's@"@ @g' | awk '{print $2}'`
		dir=`echo $i | sed 's@/start.sh@@g'`

		teamdirinfo[$count]=$name"+@+"$dir"+@+"${#name}

		count=$(($count+1))

	done

	#ソート
	teamdirinfo=(`echo "${teamdirinfo[*]}" | sort -f`)

	#チーム名最大値取得
	maxteamname=`echo "${teamdirinfo[*]}" | sed 's/+@+/ /g' | awk '{if(m<$3) m=$3} END{print m}'`

	#リスト表示
	line=0

	clear

	echo
	echo "▼ チームリスト"
	echo

	for i in ${teamdirinfo[@]};do

		name=`echo $i | sed 's/+@+/ /g' | awk '{print $1}'`
		dir=`echo $i | sed 's/+@+/ /g' | awk '{print $2}'`
		#dir=`echo $i | sed 's/+@+/ /g' | awk '{print $2}' | sed 's@/src@@g'`

		printf "%3d  %s" $(($line+1)) $name

		for ((space=$(($maxteamname-${#name}+5)); space>0; space--)); do

			printf " "

		done

		printf "%s\n"  $dir

		line=$(($line+1))

	done

	echo
	echo "上のリストからチームを選択してください。"

	#チーム選択
	for ((i=0;i<2;i++)); do

		if [ -z ${team[$i]} ]; then

			echo
			echo -n "team_"$(($i+1))" > "

			while true
			do

				read number

				if [ $number -ge 1 ] && [ $number -le $line ]; then

					break

				fi

				printf "もう一度入力してください > "

			done

			team[$i]=`echo ${teamdirinfo[$(($number-1))]} | sed 's/+@+/ /g' | awk '{print $2}'`

		fi

	done

fi



#倍速設定
if [ -z $synch_mode ] || [ ! $synch_mode = "false" -a ! $synch_mode = "true" ]; then

	echo
	echo "倍速にしますか？(y/n)"

	while true
	do
		read modeselect

		#エラー入力チェック
		if [ $modeselect = "n" ];then

			synch_mode="false"
			break

		fi

  	if [ $modeselect = "y" ]; then

			synch_mode="true"
			break

		fi

		echo "もう一度入力してください。"

	done

fi

#倍速設定書き込み
if [ $synch_mode = "false" ]; then

	sed -i 's@server::synch_mode = true@server::synch_mode = false@g' /home/$USER/.rcssserver/server.conf
	modemenu="無効"

else

	sed -i 's@server::synch_mode = false@server::synch_mode = true@g' /home/$USER/.rcssserver/server.conf
	modemenu="有効"

fi

trap 'last' {1,2,3,15}

killcommand(){

	kill `ps aux | grep "rcssserver" | awk '{print $2}'` &>/dev/null
	kill `ps aux | grep "soccerwindow2" | awk '{print $2}'` &>/dev/null
	kill `ps aux | grep "start.sh" | awk '{print $2}'` &>/dev/null

	exit 1

}

last(){

  echo
  echo
  echo "シミュレーションを中断します...(´ ･ω･｀)ｼｮﾎﾞﾝ"
	echo

	killcommand

  exit 1

}

#チーム名取り出し
teamname[0]=`grep "teamname=" ${team[0]}/start.sh | sed -n 1P | sed 's@"@ @g' | awk '{print $2}'`
teamname[1]=`grep "teamname=" ${team[1]}/start.sh | sed -n 1P | sed 's@"@ @g' | awk '{print $2}'`

if [ ${teamname[0]} = ${teamname[1]} ]; then

	teamname[0]="left"
	teamname[1]="right"

fi

#起動
gnome-terminal --geometry=10x10 -x  bash -c  "

	rcssserver

	read waitserver

" &

gnome-terminal --geometry=10x10 -x  bash -c  "

	soccerwindow2

	read waitserver

"

gnome-terminal -x  bash -c  "

	cd "${team[0]}"

	bash start.sh -t ${teamname[0]}

	read waitserver

"

gnome-terminal -x  bash -c  "

	cd "${team[1]}"

	bash start.sh -t ${teamname[1]}

	read waitserver

"

clear

echo "以下の条件でシミュレーションを行います"
echo
echo ${team[0]}
echo ${team[1]}

game_progress=()

echo
echo
echo "シミュレーションを開始します！"

cd `grep "server::text_log_dir = " /home/$USER/.rcssserver/server.conf | sed "s@'@@g" | awk '{print $3}' | sed "s@~@/home/$USER@g"`

while true
do

	sleep 1

	if [ `grep -c "half_time" incomplete.rcl` -eq 1 ] && [ -z ${game_progress[0]} ] ; then

		echo
		echo "ハーフタイム"
		echo

		game_progress[0]=1

	fi

#	if [ `grep -c "time_extended" incomplete.rcl` -eq 1 ] && [ ${game_progress[1]} -eq 0 ] ; then

#		echo
#		echo "延長線"
#		echo

	#	game_progress[0]=1

	#fi

	if [ `grep -c "time_up" incomplete.rcl` -eq 1 ]; then

		echo
		echo "ゲームセット！"
		echo
		echo

		killcommand

	fi



done
