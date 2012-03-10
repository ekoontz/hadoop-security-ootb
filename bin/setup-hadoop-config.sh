#!/usr/bin/env bash
bin=`which $0`
bin=`dirname ${bin}`
bin=`cd "$bin"; pwd`

LOCAL_ETC=$bin/../etc/hadoop
ETC=/usr/lib/hadoop/etc/hadoop
cat $LOCAL_ETC/core-site.template.xml | sed s/\\\${MASTER}/`hostname -f`/g > $ETC/core-site.xml

mv $ETC/hdfs-site.xml /tmp
ln -s $ETC/core-site.xml $ETC/hdfs-site.xml
mv $ETC/yarn-site.xml /tmp
ln -s $ETC/core-site.xml $ETC/yarn-site.xml



