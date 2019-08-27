INTELLIJ=`find ~/ -type d -name ".*" -prune -o -type f -print | grep "idea.sh" | sed 's@/bin/idea.sh@@g'`

wget http://ftp.jaist.ac.jp/pub/mergedoc/pleiades/build/stable/pleiades.zip
unzip pleiades.zip -d $INTELLIJ
echo -Xverify:none >> $INTELLIJ/bin/idea64.vmoptions
echo -javaagent:$INTELLIJ/plugins/jp.sourceforge.mergedoc.pleiades/pleiades.jar >> $INTELLIJ/bin/idea64.vmoptions
echo -Xverify:none >> $INTELLIJ/bin/idea.vmoptions
echo -javaagent:$INTELLIJ/plugins/jp.sourceforge.mergedoc.pleiades/pleiades.jar >> $INTELLIJ/bin/idea.vmoptions
rm pleiades.zip
