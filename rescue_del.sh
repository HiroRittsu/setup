#!/bin/bash
#製作者: みぐりー
#名前変更専用

echo
echo "新しくダウンロードします"
wget -N -O RioneLauncher.sh `curl https://raw.githubusercontent.com/MiglyA/bash-rescue/master/histry.txt | grep "RioneLauncher-link" | awk '{print $2}'` &>/dev/null
echo
echo
echo
echo "重要!!!!!!!!"
echo
echo "レスキュー起動補助ツールは、RioneLauncherと変更されました!"
echo
echo
echo "次回起動する場合「bash RioneLauncher.sh」と打ち込んでください。"
echo
echo
echo
echo
echo
rm $0
exit 1

