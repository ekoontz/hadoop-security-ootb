#!/usr/bin/env bash                                                                                

if [ -z $MASTER ]; then
    echo "you must define \$MASTER in your environment."
    exit
fi

ETC=$bin/../etc/hadoop
cat $ETC/core-site.template.xml | sed s/\\\${MASTER}/$MASTER/g \
| sed s/\\\${SLAVE}/`hostname -f`/g \
| grep -v _TEMPLATE > $ETC/core-site.xml

mv $ETC/hdfs-site.xml /tmp
ln -s $ETC/core-site.xml $ETC/hdfs-site.xml
mv $ETC/yarn-site.xml /tmp
ln -s $ETC/core-site.xml $ETC/yarn-site.xml

