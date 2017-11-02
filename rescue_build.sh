#!/bin/bash

#gitフォルダの場所
git_address="/home/$USER/git"

#使用するマップを固定したい場合は、例のようにフルパスを指定してください。
#固定したくない場合は0を入れてください。
 #例) map="/home/migly/git/roborescue-v1.2/maps/gml/Kobe2013/map"
map=/home/$USER/git/roborescue-v1.2/maps/gml/test
#map=0

#使用するソースを固定したい場合は、例のようにフルパスを指定してください。
#固定したくない場合は0を入れてください。
 #例) src="/home/migly/git/sample"
src=/home/$USER/git/sample


#usernae=migly

#dir=/home/$username/git
	
#echo $dir
	
#gitフォルダの有無を確認。
if [ ! -e $git_address ]; then

	echo
	echo "gitフォルダがありません。出直してきてください。"
	echo
	exit 1
	
fi

#map&src-select引数
echo $1

#マップ選択

#`find /home/migly/git/roborescue-v1.2/maps -name map.gml | awk '{print $2-NF}'`

#find /home/migly/git/roborescue-v1.2/maps -name map.gml>>found


#filelist='cat found|xargs'

#for i in $filelist;do

#	echo $i
	
#done

#echo "${found[@]}"


#mapdir=()

if [ ! -f $map/scenario.xml ] || [ ! $1 -eq 0 ]; then

	clear

	#マップディレクトリの登録

	mapdir=(`find $git_address/roborescue-v1.2/maps -name scenario.xml`)

	
	
	line=0

	for i in ${mapdir[@]};do
	
		mapdir[$((line++))]=`echo ${i} | sed 's/scenario.xml//g'`
	
		#line=$(($line+1))
	
		#echo $line"  "${mapdir[$(($line-1))]}
	
	done



	#マップリスト表示

	line=0
	echo

	for i in ${mapdir[@]};do
	
		echo " "$((++line))"  " `echo ${i} | sed 's@/map/@@g' | sed 's@/@ @g' |awk '{print $NF}'`

		#line=$(($line+1))
	
	done

	echo
	echo "上のリストからマップ番号を選択してください。"


	while true
	do
		#echo $line
		read mapnumber 

		#エラー入力チェック
		if [ 0 -lt $mapnumber ] && [ $mapnumber -le $line ]; then 
	
			break
	
		fi
		
		echo "もう一度入力してください。"
	done



	#アドレス代入
	map=${mapdir[$(($mapnumber-1))]}


fi


#ソース選択

#ソースディレクトリの登録
if [ ! -f $src/library/rescue/adf/adf-core.jar ] || [ ! $1 -eq 0 ]; then

	srcdir=(`find $git_address -name adf-core.jar`)

	line=0

	for s in ${srcdir[@]};do
	
		srcdir[$((line++))]=`echo ${s} | sed 's@/library/rescue/adf/adf-core.jar@@g'`
	
		#line=$(($line+1))
	
		#echo $line"  "${srcdir[$(($line-1))]}
	
	done

	echo ; echo ; echo ; echo

	clear
	#echo "ソースコードの番号を選択してください。"

	#ソースリスト表示

	line=0
	echo
	for s in ${srcdir[@]};do
	
		echo " "$((++line))"  " `echo ${s} | sed 's@/@ @g' |awk '{print $NF}'`

		#line=$(($line+1))
	
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


fi

clear
echo
echo -n "マップ情報読み込み..."


#読み込み最大値取得

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



#rm tempfile





road_max=`grep -c "rcr:road gml:id=" $map/map.gml`
building_max=`grep -c "rcr:building gml:id=" $map/map.gml`

#エラーチェック
#building_max=0
#road_max=0

maxlist=( $building_max $road_max $civilian_max $ambulanceteam_max $firebrigade_max $policeforce_max )

errerline=0

for l in ${maxlist[@]};
do

	if [ $l -eq 0 ]; then

		maxlist[$errerline]=-1

	fi

errerline=$((errerline+1))

done






IFS=$' \t\n'




echo -e "\e[0;0H"

#echo -e "\e[K\c"
echo "マップ情報読み込み...完了"

echo

echo "以下の環境を読み込んでいます..."
echo
echo "        マップ ："`echo $map | sed 's@/map/@@g' | sed 's@/@ @g' |awk '{print $NF}'`
echo "  ソースコード ："`echo $src | sed 's@/@ @g' |awk '{print $NF}'`
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

#touch maplog.txt

#| tee /home/$USER/Desktop/maplog.log


#echo "hoge" | tee hoge.log

rm server.log &>/dev/null
rm src.log &>/dev/null

touch src.log

trap 'last'  {1,2,3,15}

#マップ起動
gnome-terminal --geometry=10x10 -x  bash -c  "

	cd $git_address/roborescue-v1.2/boot/

	bash start-comprun.sh -m $map | tee `pwd`/server.log
	
	exec bash
	
"

#ソース起動
gnome-terminal --geometry=10x10 -x  bash -c   "

	cd $src

	bash compile.sh>>`pwd`/src.log 2>&1
	
	bash start.sh -1 -1 -1 -1 -1 -1 localhost | tee -a `pwd`/src.log
	
	exec bash
	
"

#プロセス取得
prosess=(`ps aux | grep "bash -c" | awk '{print $2}'`)


last () {
  echo
  echo 
  echo "シミュレーションを中断します...(´ ･ω･｀)ｼｮﾎﾞﾝ"
  echo
  kill `ps aux | grep "bash -c" | awk '{print $2}'` &>/dev/null
  exit 1
}


errerbreak () {

	echo ; echo
	echo "内部で何らかのエラーが発生しました" 
	echo "シミュレーションを終了します...m(._.*)mﾍﾟｺｯ"
	echo
	kill ${prosess[@]} &>/dev/null
	exit 1

}




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
	
	#ロード100%に修正するマン
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
 			kill `ps aux | grep "bash -c" | awk '{print $2}'` &>/dev/null
  			exit 1
		
		fi
		
		#sucsess
		if [ `grep -c "Done." src.log` -eq 1 ]; then
		
			#echo ; echo
			echo "オールグリーン" 
			#break
		
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
	
	echo -e "\e[8;8H"

done


#src.logの読み込み
while true
do

#sed -n 10,20p file
# grep -c "Linux" target_file
	if [ -f src.log ]; then
			
			tail -f -n 20 src.log

	fi	

sleep 1

done



