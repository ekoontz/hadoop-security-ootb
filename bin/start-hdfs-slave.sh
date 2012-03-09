#!/usr/bin/env bash

bin=/usr/lib/hadoop/bin

export HADOOP_SECURE_DN_USER=hdfs
#wipe out existing install, if any.
sudo rm -rf /tmp/hadoop/*
sudo su root -c "JAVA_HOME=$JAVA_HOME HADOOP_SECURE_DN_USER=hdfs $bin/hdfs datanode &"
