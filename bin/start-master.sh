#!/bin/sh
bin=`which $0`
bin=`dirname ${bin}`
bin=`cd "$bin"; pwd`

$bin/shutdown.sh
$bin/setup-master.sh

$bin/start-hdfs-master.sh
$bin/start-yarn-master.sh

#need to wait for one datanode to come up before we can do this:
#export JAVA_HOME=/usr/lib/jvm/jre-openjdk
#sudo su hdfs -c "JAVA_HOME=$JAVA_HOME $bin/hdfs-permissions.sh"

sudo mkdir /tmp/hadoop/tmp
sudo chown -R hdfs:hadoop /tmp/hadoop/tmp
sudo chmod -R 775 /tmp/hadoop/tmp


