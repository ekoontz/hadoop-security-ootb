#!/usr/bin/env bash
#get sudo permission from user, if necessary: 'echo' is just an inoccuous thing to run to get the necessary permission.
sudo echo 

#kill any currently-running daemons, if any.
sudo pkill -f NameNode
sudo pkill -f DataNode
sudo pkill -f ResourceManager
sudo pkill -f NodeManager
