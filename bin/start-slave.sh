#!/bin/sh
bin=`which $0`
bin=`dirname ${bin}`
bin=`cd "$bin"; pwd`

$bin/shutdown-slave.sh
$bin/setup-slave.sh 
$bin/start-hdfs-slave.sh
$bin/start-yarn-slave.sh




