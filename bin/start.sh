#!/bin/sh
bin=`which $0`
bin=`dirname ${bin}`
bin=`cd "$bin"; pwd`

$bin/shutdown.sh

sudo $bin/krb5.sh
$bin/setup-single-node.sh 
sudo $bin/permissions.sh 

$bin/start-hdfs.sh
$bin/start-yarn.sh
export JAVA_HOME=/usr/lib/jvm/jre-openjdk
sudo su hdfs -c "JAVA_HOME=$JAVA_HOME $bin/hdfs-permissions.sh"

sudo mkdir /tmp/hadoop/tmp
sudo chown -R hdfs:hadoop /tmp/hadoop/tmp
sudo chmod -R 775 /tmp/hadoop/tmp


