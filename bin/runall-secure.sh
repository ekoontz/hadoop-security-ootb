#!/usr/bin/env bash
# no historymanager or secondary namenode yet.
bin=`which $0`
bin=`dirname ${bin}`
bin=`cd "$bin"; pwd`

export HADOOP_SECURE_DN_USER=hdfs

#get sudo permission from user, if necessary: 'echo' is just an inoccuous thing to run to get the necessary permission.
sudo echo 

#kill any currently-running daemons, if any.
sudo pkill -f NameNode
sudo pkill -f DataNode
sudo pkill -f ResourceManager
sudo pkill -f NodeManager

#wipe out existing install, if any.
sudo rm -rf /tmp/hadoop/*
sudo su hdfs -c "JAVA_HOME=$JAVA_HOME $bin/hdfs namenode -format"

sudo su hdfs -c "JAVA_HOME=$JAVA_HOME $bin/hdfs namenode &"

#sleep because it seems like possibly dn will give up and exit
#if namenode doesn't start fast enough.
sleep 5
sudo su root -c "JAVA_HOME=$JAVA_HOME HADOOP_SECURE_DN_USER=hdfs $bin/hdfs datanode &"

sudo su yarn -c "JAVA_HOME=$JAVA_HOME $bin/yarn resourcemanager &"

#sleep because nodemanager will die pretty quickly without
#a resourcemanager (MAPREDUCE-3676)
sleep 5

sudo mkdir -p /tmp/hadoop/nm-local-dirs
sudo chown -R yarn /tmp/hadoop/nm-local-dirs

sudo su yarn -c "JAVA_HOME=$JAVA_HOME $bin/yarn nodemanager &"

#finally, set permissions.
#first, set up credentials so that we have nn's permission to modify HDFS.
kinit -k -t $bin/../etc/hadoop/security/nn.keytab nn/`hostname -f`@HADOOP.LOCALDOMAIN
kinit -R

bin/hadoop fs -chmod 755 hdfs://`hostname -f`:9000/

bin/hadoop fs -mkdir hdfs://`hostname -f`:9000/tmp
bin/hadoop fs -chown hdfs:hadoop hdfs://`hostname -f`:9000/tmp
bin/hadoop fs -chmod 777 hdfs://`hostname -f`:9000/tmp # ('t')?

bin/hadoop fs -mkdir hdfs://`hostname -f`:9000/user
bin/hadoop fs -chown hdfs:hadoop hdfs://`hostname -f`:9000/user
bin/hadoop fs -chmod 775 hdfs://`hostname -f`:9000/user

bin/hadoop fs -mkdir hdfs://`hostname -f`:9000/yarn
bin/hadoop fs -chown yarn:hadoop hdfs://`hostname -f`:9000/yarn/
bin/hadoop fs -chmod 777 hdfs://`hostname -f`:9000/yarn/ # ('t')?

#do we need both /yarn and /tmp/yarn ?
bin/hadoop fs -mkdir hdfs://`hostname -f`:9000/tmp/yarn
bin/hadoop fs -chown yarn:hadoop hdfs://`hostname -f`:9000/tmp/yarn/
bin/hadoop fs -chmod 777 hdfs://`hostname -f`:9000/tmp/yarn/ # ('t')?


bin/hadoop fs -mkdir hdfs://`hostname -f`:9000/mapred

bin/hadoop fs -mkdir hdfs://`hostname -f`:9000/mapred/intermediate
bin/hadoop fs -chown mapred:hadoop hdfs://`hostname -f`:9000/mapred/intermediate
bin/hadoop fs -chmod 777 hdfs://`hostname -f`:9000/mapred/intermediate

bin/hadoop fs -mkdir hdfs://`hostname -f`:9000/mapred/done
bin/hadoop fs -chown mapred:hadoop hdfs://`hostname -f`:9000/mapred/done
bin/hadoop fs -chmod 750 hdfs://`hostname -f`:9000/mapred/done


#dump the contents for diagnostics.
bin/hadoop fs -ls -R hdfs://`hostname -f`:9000/

sudo mkdir /tmp/hadoop/tmp
sudo chown -R hdfs:hadoop /tmp/hadoop/tmp
sudo chmod -R 775 /tmp/hadoop/tmp
