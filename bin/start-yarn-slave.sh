#!/usr/bin/env bash
bin=/usr/lib/hadoop/bin

#kill any currently-running daemons, if any.
sudo pkill -f NodeManager
sudo mkdir -p /tmp/hadoop/nm-local-dirs
sudo chown -R yarn /tmp/hadoop/nm-local-dirs

sudo su yarn -c "JAVA_HOME=$JAVA_HOME $bin/yarn nodemanager &"

