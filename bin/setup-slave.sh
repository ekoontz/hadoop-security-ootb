#!/usr/bin/env bash                                                                         
if [ -z $MASTER ]; then
    echo "you must define \$MASTER in your environment."
    exit
fi
SSH_PRIVATE_KEY=/usr/lib/hadoop/etc/hadoop/security/ms-shared
if [ ! -f $SSH_PRIVATE_KEY ]; then
    echo "you must have the master's private key in $SSH_PRIVATE_KEY so that the keytab may be fetched."
    exit
fi
                                                              
bin=`which $0`
bin=`dirname ${bin}`
bin=`cd "$bin"; pwd`

sudo $bin/addusers.sh

cat $bin/../etc/hadoop/krb5.conf | sed s/\\\${MASTER_HOST}/$MASTER/  >  $bin/../etc/krb5.conf
sudo cp $bin/../etc/krb5.conf /etc

sudo su - -c "MASTER=$MASTER /home/ec2-user/hadoop-security-ootb/bin/setup-hadoop-config.sh"

RESULT=$?

if [ $RESULT -gt 0 ]; then
    exit $RESULT
fi

sudo mkdir -p /usr/lib/hadoop/etc/hadoop/security
sudo scp -i $SSH_PRIVATE_KEY ec2-user@$MASTER:hadoop-security-ootb/etc/hdfs.slave.keytab /usr/lib/hadoop/etc/hadoop/security/hdfs.keytab
sudo chown hdfs /usr/lib/hadoop/etc/hadoop/security/hdfs.keytab

sudo scp -i $SSH_PRIVATE_KEY ec2-user@$MASTER:hadoop-security-ootb/etc/yarn.slave.keytab /usr/lib/hadoop/etc/hadoop/security/yarn.keytab
sudo chown yarn /usr/lib/hadoop/etc/hadoop/security/yarn.keytab

#test that keytabs work.
set -x
sudo su hdfs -c "kinit -k -t /usr/lib/hadoop/etc/hadoop/security/hdfs.keytab hdfs/`hostname -f`"
sudo su yarn -c "kinit -k -t /usr/lib/hadoop/etc/hadoop/security/yarn.keytab yarn/`hostname -f`"
