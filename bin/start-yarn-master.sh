#!/usr/bin/env bash
bin=/usr/lib/hadoop/bin

#kill any currently-running daemons, if any.
sudo pkill -f ResourceManager

sudo su yarn -c "JAVA_HOME=$JAVA_HOME $bin/yarn resourcemanager &"
