CLION=`find ~/ -type d -name ".*" -prune -o -type f -print | grep "clion.sh" | sed 's@/bin/clion.sh@@g'`

wget http://ftp.jaist.ac.jp/pub/mergedoc/pleiades/build/stable/pleiades.zip
unzip pleiades.zip -d $CLION
echo -Xverify:none >> $CLION/bin/clion64.vmoptions
echo -javaagent:$CLION/plugins/jp.sourceforge.mergedoc.pleiades/pleiades.jar >> $CLION/bin/clion64.vmoptions
echo -Xverify:none >> $CLION/bin/clion.vmoptions
echo -javaagent:$CLION/plugins/jp.sourceforge.mergedoc.pleiades/pleiades.jar >> $CLION/bin/clion.vmoptions
rm pleiades.zip
