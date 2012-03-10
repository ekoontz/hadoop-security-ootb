#!/usr/bin/env bash
bin=`which $0`
bin=`dirname ${bin}`
bin=`cd "$bin"; pwd`
if [ -z $MASTER ]; then
    echo "you must define \$MASTER in your environment."
    exit 1
fi

LOCAL_ETC=$bin/../etc/hadoop
ETC=/usr/lib/hadoop/etc/hadoop
cat $LOCAL_ETC/core-site.template.xml | sed s/\\\${MASTER}/$MASTER/g > $ETC/core-site.xml

mv $ETC/hdfs-site.xml /tmp
ln -s $ETC/core-site.xml $ETC/hdfs-site.xml
mv $ETC/yarn-site.xml /tmp
ln -s $ETC/core-site.xml $ETC/yarn-site.xml



