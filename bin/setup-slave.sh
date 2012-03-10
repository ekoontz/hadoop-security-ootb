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

cat $bin/../etc/hadoop/krb5.conf | sed s/\\\${MASTER_HOST}/`hostname -f`/  > /etc/krb5.conf

sudo $bin/setup-hadoop-config.sh

sudo mkdir -p /usr/lib/hadoop/etc/hadoop/security
sudo scp -i $SSH_PRIVATE_KEY ec2-user@$MASTER:hadoop-security-ootb/etc/hdfs.slave.keytab /usr/lib/hadoop/etc/hadoop/security/hdfs.keytab
sudo scp -i $SSH_PRIVATE_KEY ec2-user@$MASTER:hadoop-security-ootb/etc/yarn.slave.keytab /usr/lib/hadoop/etc/hadoop/security/yarn.keytab
sudo chown yarn /usr/lib/hadoop/etc/hadoop/security/yarn.keytab

#test that keytabs work.
set -x
kinit -k -t /usr/lib/hadoop/etc/hadoop/security/hdfs.keytab hdfs/`hostname -f`
kinit -k -t /usr/lib/hadoop/etc/hadoop/security/yarn.keytab yarn/`hostname -f`
