#!/bin/bash
if [[ -z $1 ]]; then
	echo "第一引数にエディタのパスを指定してください。"
	exit 0
fi

if [[ ! -e "$1" ]]; then
	echo "存在するパスを指定してください。"
	exit 0
elif [[ ! -e "$1/bin/" ]]; then
	echo "pluginsやbinディレクトリがあるパスを指定してください。"
	echo "例: $ bash jetbrains_japanese.sh /opt/webStorm/WebStorm-192.6262.59/"
	exit 0
fi

JETBRAINS_PATH=$(cd "$1" && pwd)
echo $JETBRAINS_PATH

wget http://ftp.jaist.ac.jp/pub/mergedoc/pleiades/build/stable/pleiades.zip
unzip pleiades.zip -d $JETBRAINS_PATH

for v in $(find $JETBRAINS_PATH/bin/ -name *.vmoptions); do
	echo -Xverify:none >> $v
	echo -javaagent:$JETBRAINS_PATH/plugins/jp.sourceforge.mergedoc.pleiades/pleiades.jar >> $v
done

rm pleiades.zip
