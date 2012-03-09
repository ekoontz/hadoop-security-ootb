#!/usr/bin/env bash

bin=`which $0`
bin=`dirname ${bin}`
bin=`cd "$bin"; pwd`

export HADOOP_SECURE_DN_USER=hdfs
#wipe out existing install, if any.
sudo rm -rf /tmp/hadoop/*
sudo su root -c "JAVA_HOME=$JAVA_HOME HADOOP_SECURE_DN_USER=hdfs $bin/hdfs datanode &"
