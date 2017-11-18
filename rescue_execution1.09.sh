#!/bin/bash
#製作者: みぐりー


#gitフォルダの場所
git_address="/home/$USER/git"

#使用するマップを固定したい場合は、例のようにフルパスを指定してください。
#固定したくない場合は空白で大丈夫です。
 #例) map="/home/migly/git/roborescue-v1.2/maps/gml/Kobe2013/map"
map=/home/$USER/git/roborescue-v1.2/maps/gml/test

#使用するソースを固定したい場合は、例のようにフルパスを指定してください。
#固定したくない場合は空白で大丈夫です。
 #例) src="/home/migly/git/sample"
src=/home/$USER/git/sample

#瓦礫の有無。固定する場合はtrue(瓦礫あり)もしくはfalse(瓦礫なし)を指定してください。
#固定したくない場合は空白で大丈夫です。
brockade=false
#brockade=true






#/////////////////////////////////////////////////////////////
#ここから先は改変しないでくだせぇ動作が止まっても知らないゾ？↓

#自動アップデート
CurrentVer=1.09
echo
echo "Ver.$CurrentVer"
echo
echo "バージョンチェックを行います。"
echo "※ 少し時間がかかる場合があります。"
echo

	if [ ! `curl --connect-timeout 3 https://raw.githubusercontent.com/MiglyA/bash-rescue/master/histry.txt | grep "latest" | awk '{print $2}'` = $CurrentVer ]; then &>/dev/null

		echo "自動アップデートを行います"
		wget -N -O rescue_execution.sh `curl https://raw.githubusercontent.com/MiglyA/bash-rescue/master/histry.txt | grep "url" | awk '{print $2}'` &>/dev/null
		echo
		echo "アップデート完了しました。"
		echo "再起動をおねがいします。"
		echo
		exit 1

	fi


#条件変更シグナル
ChangeConditions=0

if [ ! -z $1 ]; then

	ChangeConditions=1

fi


#gitフォルダの有無を確認。
if [ ! -e $git_address ] || [ -z $git_address ]; then

	echo
	echo "gitフォルダがありません。出直してきてください。"
	echo
	exit 1

fi

#環境変数変更
IFS=$'\t\n'

#マップディレクトリの登録
if [ ! -f $map/scenario.xml ] || [ $ChangeConditions -eq 1 ] || [ -z $map ]; then

	clear

	mapdir=(`find $git_address/roborescue-v1.2/maps -name scenario.xml`)

	if [ ${#mapdir[@]} -eq 0 ]; then

		echo
		echo "マップが見つかりません…ｷｮﾛ^(･д･｡)(｡･д･)^ｷｮﾛ"
		echo
		exit 1

	fi


	if [ ! ${#mapdir[@]} -eq 1 ]; then

		line=0

		for i in ${mapdir[@]};do

			mapdir[$((line++))]=`echo ${i} | sed 's/scenario.xml//g'`


		done



		#マップリスト表示
		line=0
		echo

		for i in ${mapdir[@]};do

			echo " "$((++line))"  " `echo ${i} | sed 's@/map/@@g' | sed 's@/@ @g' |awk '{print $NF}'`

		done

		echo
		echo "上のリストからマップ番号を選択してください。"


		while true
		do

			read mapnumber

			#エラー入力チェック
			if [ 0 -lt $mapnumber ] && [ $mapnumber -le $line ]; then

				break

			fi

			echo "もう一度入力してください。"
		done



		#アドレス代入
		map=${mapdir[$(($mapnumber-1))]}

	else

		map=`echo ${mapdir[0]} | sed 's/scenario.xml//g'`

	fi

fi


#ソース選択

#ソースディレクトリの登録
if [ ! -f $src/library/rescue/adf/adf-core.jar ] || [ $ChangeConditions -eq 1 ] || [ -z $src ]; then

	srcdir=(`find $git_address -name adf-core.jar`)


	if [ ${#srcdir[@]} -eq 0 ]; then

		echo
		echo "ソースが見つかりません…ｷｮﾛ^(･д･｡)(｡･д･)^ｷｮﾛ"
		echo
		exit 1

	fi


	if [ ! ${#srcdir[@]} -eq 1 ]; then

		line=0

		for s in ${srcdir[@]};do

			srcdir[$((line++))]=`echo ${s} | sed 's@/library/rescue/adf/adf-core.jar@@g'`

		done

		echo ; echo ; echo ; echo

		clear

		#ソースリスト表示
		line=0

		echo

		for s in ${srcdir[@]};do

			echo " "$((++line))"  " `echo ${s} | sed 's@/@ @g' |awk '{print $NF}'`

		done

		echo
		echo "上のリストからソースコードを選択してください。"


		while true
		do
			read srcnumber

			#エラー入力チェック
			if [ 0 -lt $srcnumber ] && [ $srcnumber -le $line ]; then

				break

			fi

			echo "もう一度入力してください。"

		done


		#アドレス代入
		src=${srcdir[$(($srcnumber-1))]}

	else

		src=`echo ${srcdir[0]} | sed 's@/library/rescue/adf/adf-core.jar@@g'`

	fi

fi


clear
#瓦礫有無選択
#if [ $brockade -eq 0 ]; then
if [ -z $brockade ] || [ $ChangeConditions -eq 1 ]; then

	echo
	echo "瓦礫を配置しますか？(y/n)"

	while true
	do
		read brockadeselect

		#エラー入力チェック
		if [ $brockadeselect = "y" ]; then

			sed -i -e 's/false/true/g' $git_address/roborescue-v1.2/boot/config/collapse.cfg
			brockade="true"
			break


		fi

		if [ $brockadeselect = "n" ];then

			sed -i -e 's/true/false/g' $git_address/roborescue-v1.2/boot/config/collapse.cfg
			brockade="false"
			break

		fi

		echo "もう一度入力してください。"

	done

fi


clear
echo
echo -n "マップ情報読み込み..."


#読み込み最大値取得

#環境変数変更
IFS=$'\n'

#エージェント
scenariolist=(`cat $map/scenario.xml`)

line_count=1
before_comment=0
after_comment=0

for line in ${scenariolist[@]}; do

	if [ `echo $line | grep '<!--'` ]; then

		before_comment=$line_count

	fi


	if [ `echo $line | grep '\-->'` ]; then

		after_comment=$line_count

	fi


	if [ ! $before_comment = 0 ] && [ ! $after_comment = 0 ]; then

		for ((i=before_comment; i <= $after_comment; i++)); do

			unset scenariolist[$(($i-1))]

		done

		before_comment=0
		after_comment=0

	fi

	line_count=$(($line_count+1))

done

echo


for n in ${scenariolist[@]}; do

	echo $n>>tempfile

done

civilian_max=`grep -c "civilian" tempfile`
policeforce_max=`grep -c "policeforce" tempfile`
firebrigade_max=`grep -c "firebrigade" tempfile`
ambulanceteam_max=`grep -c "ambulanceteam" tempfile`

rm tempfile &>/dev/null




#building&road
#コメントアウトをとってもいいですけど処理がめちゃくちゃ重くなりますぞ...

#maplist=(`cat $map/map.gml`)

#line_count=1
#before_comment=0
#after_comment=0

#echo ${#maplist[@]}

#for line in ${maplist[@]}; do

#	if [ `echo $line | grep '*'` ] && [ $before_comment = 0 ]; then

#		before_comment=$line_count

#	fi


#	if [ `echo $line | grep '*'` ] && [ $after_comment = 0 ]; then

#		after_comment=$line_count

#	fi


#	if [ `echo $line | grep '//'` ] && [ $before_comment = 0 ]; then

#		before_comment=$line_count
#		after_comment=$line_count

#	fi


#	if [ ! $before_comment = 0 ] && [ ! $after_comment = 0 ]; then

#		for ((i=before_comment; i <= $after_comment; i++)); do

#			unset maplist[$(($i-1))]

#		done

#		before_comment=0
#		after_comment=0

#	fi

#	line_count=$(($line_count+1))
#echo $line_count
#done

#echo

#echo text
#for n in ${maplist[@]}; do

#	echo $n>>tempfile

#done

#road_max=`grep -c "rcr:road gml:id=" $map/tempfile`
#building_max=`grep -c "rcr:building gml:id=" $map/tempfile`

#rm tempfile





road_max=`grep -c "rcr:road gml:id=" $map/map.gml`
building_max=`grep -c "rcr:building gml:id=" $map/map.gml`


#エラーチェック
maxlist=( $building_max $road_max $civilian_max $ambulanceteam_max $firebrigade_max $policeforce_max )

errerline=0

for l in ${maxlist[@]};
do

	if [ $l -eq 0 ]; then

		maxlist[$errerline]=-1

	fi

errerline=$((errerline+1))

done


#環境変数変更
IFS=$' \t\n'

rm server.log &>/dev/null
rm src.log &>/dev/null

touch src.log
touch server.log

#[C+ctrl]検知
trap 'last' {1,2,3,15}

killcommand(){

	kill `ps aux | grep "start-comprun.sh" | grep -v "gnome-terminal" | awk '{print $2}'` &>/dev/null
	sleep 0.5
	kill `ps aux | grep "compile.sh" | awk '{print $2}'` &>/dev/null
	kill `ps aux | grep "start.sh -1 -1 -1 -1 -1 -1 localhost" | awk '{print $2}'` &>/dev/null

}

last(){

  echo
  echo
  echo "シミュレーションを中断します...(´ ･ω･｀)ｼｮﾎﾞﾝ"

	if [ ! -z `grep -a -C 0 'Score:' $git_address/roborescue-v1.2/boot/logs/kernel.log | tail -n 1 | awk '{print $5}'` ]; then

		echo
		echo "◆　これまでのスコア : "`grep -a -C 0 'Score:' $git_address/roborescue-v1.2/boot/logs/kernel.log | tail -n 1 | awk '{print $5}'`

	fi
	echo

	killcommand

  exit 1

}

errerbreak(){

	echo ; echo
	echo "内部で何らかのエラーが発生しました"
	echo "シミュレーションを終了します...m(._.*)mﾍﾟｺｯ"
	echo

	killcommand

	exit 1

}


location=`pwd`

cd $git_address/roborescue-v1.2/boot/

#マップ起動
gnome-terminal --geometry=10x10 -x  bash -c  "

	./start-comprun.sh -m ../`echo $map | sed "s@$git_address/roborescue-v1.2/@@g"`/ 2>&1 | tee $location/server.log

	read waitserver

" &


#サーバー待機
echo
echo "サーバー起動中..."
echo
echo "※ terminatorで実行すると以下にエラーが出る場合がありますが、無視して構いません。"

while true
do

	if [ ! `grep -c "waiting for misc to connect..." $location/server.log` -eq 0 ]; then

		break

	fi

done
clear

echo -e "\e[0;0H"

echo "マップ情報読み込み...完了"

echo

echo "以下の環境を読み込んでいます..."
echo
echo "        マップ ："`echo $map | sed 's@/map/@@g' | sed 's@/@ @g' |awk '{print $NF}'`
echo "  ソースコード ："`echo $src | sed 's@/@ @g' |awk '{print $NF}'`
echo "  　　　　瓦礫 ："$brockade
echo
<<com
echo "マップ情報："
echo "       Building - "$building_max
echo "           Road - "$road_max
echo "       Civilian - "$civilian_max
echo "  AmbulanceTeam - "$ambulanceteam_max
echo "    FireBrigade - "$firebrigade_max
echo "    PoliceForce - "$policeforce_max
echo
com

#ソース起動
gnome-terminal --geometry=10x10 -x  bash -c   "

	cd $src

	bash compile.sh >> $location/src.log 2>&1

	bash start.sh -1 -1 -1 -1 -1 -1 localhost 2>&1 | tee $location/src.log

	read waitsrc

"

cd $location

lording_ber(){

	if [ $1 -lt 0 ]; then

		echo "　　サーバーから読み込むことができませんでした。　"

	else

		for (( ber=1; ber <= $(($1/2)); ber++ ));
		do

			echo -n "#"

		done

		for (( ber=1; ber <= $((50-$1/2)); ber++ ));
		do

			echo -n "_"

		done

	fi

}

while true
do

	#ログ読み込み
	building_read=`grep -c "floor:" server.log`
	road_read=`grep -c "Road " server.log`
	ambulanceteam_read=`grep -c "PlatoonAmbulance@" src.log`
	firebrigade_read=`grep -c "PlatoonFire@" src.log`
	policeforce_read=`grep -c "PlatoonPolice@" src.log`
	civilian_read=$((`cat server.log | grep "INFO launcher : Launching instance" | awk '{print $6}' | sed -e 's/[^0-9]//g' | awk '{if (max<$1) max=$1} END {print max}'`-1))

	if [ $civilian_read -lt 0 ]; then

		civilian_read=0

	fi

	#ロード絶対100%に修正するマン
	if [ ! $ambulanceteam_read -eq 0 ] || [ ! $firebrigade_read -eq 0 ] || [ ! $civilian_read -eq 0 ] || [ ! $policeforce_read -eq 0 ]; then

		if [ ! $road_max -eq 0 ]; then

			road_read=${maxlist[1]}

		fi

	fi


	#進行度表示
	echo -e "\e[K\c"
	echo "      Building[" `lording_ber $(($building_read*100/${maxlist[0]}))` "]" $(($building_read*100/${maxlist[0]}))"%"
	echo

	echo -e "\e[K\c"
	echo "          Road[" `lording_ber $(($road_read*100/${maxlist[1]}))` "]" $(($road_read*100/${maxlist[1]}))"%"
	echo

	echo -e "\e[K\c"
	echo "      Civilian[" `lording_ber $(($civilian_read*100/${maxlist[2]}))` "]" $(($civilian_read*100/${maxlist[2]}))"%"
	echo

	echo -e "\e[K\c"
	echo " AmbulanceTeam[" `lording_ber $(($ambulanceteam_read*100/${maxlist[3]}))` "]" $(($ambulanceteam_read*100/${maxlist[3]}))"%"
	echo

	echo -e "\e[K\c"
	echo "   FireBrigade[" `lording_ber $(($firebrigade_read*100/${maxlist[4]}))` "]" $(($firebrigade_read*100/${maxlist[4]}))"%"
	echo

	echo -e "\e[K\c"
	echo "   PoliceForce[" `lording_ber $(($policeforce_read*100/${maxlist[5]}))` "]" $(($policeforce_read*100/${maxlist[5]}))"%"
	echo

	echo -e "\e[K\c"
	echo
	echo -n "  コンパイル中..."


	#エラーチェック

	if [ -f src.log ]; then

		#errer
		if [ `grep -c "Failed." src.log` -eq 1 ]; then

			echo "エラー"
			echo
			echo "エラー内容↓"
			echo
			cat src.log
			echo
  			echo "コンパイルエラー...開始できませんでした...ｻｰｾﾝ( ・ω ・)ゞ"
 			echo "エラー内容はsrc.logでも確認できます。"
 			echo

 			killcommand

  			exit 1

		fi

		#sucsess
		if [ `grep -c "Done." src.log` -eq 1 ]; then

			echo "All Green"

		fi

	fi



	if [ `grep -c "Loader is not found." src.log` -eq 1 ]; then

		errerbreak

	fi



	if [ ! `grep -c "Done connecting to server" src.log` -eq 0 ]; then

		if [ `cat src.log | grep "Done connecting to server" | awk '{print $6}' | sed -e 's/(//g'` -eq 0 ]; then

			errerbreak

		fi

		if [ `cat src.log | grep "Done connecting to server" | awk '{print $6}' | sed -e 's/(//g'` -gt 0 ] && [ `grep -c "failed: No more agents" server.log` -eq 1 ]; then

			echo ; echo
			echo "読み込み完了"
			echo
			echo
			echo
			echo "● シミュレーションを開始します！！"
			echo "　※ 中断する場合は[C+Ctrl]を入力してください"
			echo
			echo
			echo "＜端末情報＞"
			echo

			break

		fi

	fi

	sleep 1

	echo -e "\e[9;9H"

done

#src.logの読み込み
lastline=`grep -e "FINISH" -n src.log | sed -e 's/:.*//g' | awk '{if (max<$1) max=$1} END {print max}'`

while true
do

	tail -n $((`wc -l src.log | awk '{print $1}'`-$lastline)) src.log

	lastline=`wc -l src.log | awk '{print $1}'`

	if [ `grep -c "Score:" server.log` -eq 1 ]; then

		echo
		echo "● シミュレーション終了！！"
		echo
		echo "◆ 最終スコアは"`cat server.log | grep "Score:" | awk '{print $2}'`"でした。"
		echo `date +%Y/%m/%d_%H:%M`　"マップ: "`echo $map | sed 's@/map/@@g' | sed 's@/@ @g' |awk '{print $NF}'`　"スコア: "`cat server.log | grep "Score:" | awk '{print $2}'` >> score.log
		echo
		echo "スコアは'score.log'に記録しました。"
		echo

		killcommand

		exit 1

	fi

	sleep 1

done
