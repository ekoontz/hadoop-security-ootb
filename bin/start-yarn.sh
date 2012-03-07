#!/usr/bin/env bash
# no historymanager or secondary namenode yet.
bin=`which $0`
bin=`dirname ${bin}`
bin=`cd "$bin"; pwd`

#get sudo permission from user, if necessary: 'echo' is just an inoccuous thing to run to get the necessary permission.
sudo echo 

#kill any currently-running daemons, if any.
sudo pkill -f ResourceManager
sudo pkill -f NodeManager

sudo su yarn -c "JAVA_HOME=$JAVA_HOME $bin/yarn resourcemanager &"

#sleep because nodemanager will die pretty quickly without
#a resourcemanager (MAPREDUCE-3676)
sleep 5

sudo mkdir -p /tmp/hadoop/nm-local-dirs
sudo chown -R yarn /tmp/hadoop/nm-local-dirs

sudo su yarn -c "JAVA_HOME=$JAVA_HOME $bin/yarn nodemanager &"
