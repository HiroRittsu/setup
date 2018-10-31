PYCHARM=`find ~/ -type d -name ".*" -prune -o -type f -print | grep "pycharm.sh" | sed 's@/bin/pycharm.sh@@g'`

wget http://ftp.jaist.ac.jp/pub/mergedoc/pleiades/build/stable/pleiades.zip
unzip pleiades.zip -d $PYCHARM
echo -Xverify:none >> $PYCHARM/bin/pycharm64.vmoptions
echo -javaagent:$PYCHARM/plugins/jp.sourceforge.mergedoc.pleiades/pleiades.jar >> $PYCHARM/bin/pycharm64.vmoptions
echo -Xverify:none >> $PYCHARM/bin/pycharm.vmoptions
echo -javaagent:$PYCHARM/plugins/jp.sourceforge.mergedoc.pleiades/pleiades.jar >> $PYCHARM/bin/pycharm.vmoptions
rm pleiades.zip
