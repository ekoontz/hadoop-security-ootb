#!/usr/bin/env bash
bin=`which $0`
bin=`dirname ${bin}`
bin=`cd "$bin"; pwd`

ETC=$bin/../etc/hadoop
cat $ETC/core-site.template.xml | sed s/_MASTER/`hostname -f`/g \
| sed s/_SLAVE/`hostname -f`/g \
| grep -v _TEMPLATE \
| perl -pe "s|_HOME|$HOME|g" > $ETC/core-site.xml

mv $ETC/hdfs-site.xml /tmp
ln -s $ETC/core-site.xml $ETC/hdfs-site.xml
mv $ETC/yarn-site.xml /tmp
ln -s $ETC/core-site.xml $ETC/yarn-site.xml



