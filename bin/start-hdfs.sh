#!/usr/bin/env bash
# no secondary namenode yet.

bin=`which $0`
bin=`dirname ${bin}`
bin=`cd "$bin"; pwd`

# <look in source directory's classes first to avoid need to recompile and package everything. -->
export HADOOP_USER_CLASSPATH_FIRST=true
export HADOOP_CLASSPATH=/home/ec2-user/hadoop-common/hadoop-hdfs-project/hadoop-hdfs/target/classes

export HADOOP_SECURE_DN_USER=hdfs

#get sudo permission from user, if necessary: 'echo' is just an inoccuous thing to run to get the necessary permission.
sudo echo 

#kill any currently-running daemons, if any.
sudo pkill -f NameNode
sudo pkill -f DataNode

#wipe out existing install, if any.
sudo rm -rf /tmp/hadoop/*
JAVA_HOME=/usr/java/latest
sudo su hdfs -c "JAVA_HOME=$JAVA_HOME $bin/hdfs namenode -format"

sudo su hdfs -c "HADOOP_CLASSPATH=$HADOOP_CLASSPATH HADOOP_USER_CLASSPATH_FIRST=true JAVA_HOME=$JAVA_HOME $bin/hdfs namenode &"

#sleep because it seems like possibly dn will give up and exit
#if namenode doesn't start fast enough.
sleep 5
sudo su root -c "JAVA_HOME=$JAVA_HOME HADOOP_SECURE_DN_USER=hdfs $bin/hdfs datanode &"
