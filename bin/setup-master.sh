#!/bin/sh
bin=`which $0`
bin=`dirname ${bin}`
bin=`cd "$bin"; pwd`

sudo $bin/krb5.sh
sudo su - -c "MASTER=`hostname -f` /home/ec2-user/hadoop-security-ootb/bin/setup-hadoop-config.sh"
sudo $bin/permissions.sh 



