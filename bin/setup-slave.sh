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

LOCAL_ETC=$bin/../etc/hadoop
HADOOP_ETC=/usr/lib/hadoop/etc/hadoop
ETC=/etc

cat $LOCAL_ETC/krb5.conf | sed s/\\\${MASTER_HOST}/$MASTER/  > $ETC/krb5.conf

cat $LOCAL_ETC/core-site.template.xml | sed s/\\\${MASTER}/$MASTER/g \
| sed s/\\\${SLAVE}/`hostname -f`/g \
| grep -v _TEMPLATE > $HADOOP_ETC/core-site.xml

mv $HADOOP_ETC/hdfs-site.xml /tmp
ln -s $HADOOP_ETC/core-site.xml $HADOOP_ETC/hdfs-site.xml
mv $HADOOP_ETC/yarn-site.xml /tmp
ln -s $HADOOP_ETC/core-site.xml $HADOOP_ETC/yarn-site.xml

sudo rm /usr/lib/hadoop/etc/hadoop/security/*.keytab
sudo mkdir -p /usr/lib/hadoop/etc/hadoop/security
sudo scp -i $SSH_PRIVATE_KEY ec2-user@$MASTER:hadoop-security-ootb/etc/hdfs.slave.keytab /usr/lib/hadoop/etc/hadoop/security/hdfs.keytab
sudo scp -i $SSH_PRIVATE_KEY ec2-user@$MASTER:hadoop-security-ootb/etc/yarn.slave.keytab /usr/lib/hadoop/etc/hadoop/security/yarn.keytab
sudo chown yarn /usr/lib/hadoop/etc/hadoop/security/yarn.keytab

#test that keytabs work.
set -x
kinit -k -t /usr/lib/hadoop/etc/hadoop/security/hdfs.keytab hdfs/`hostname -f`
kinit -k -t /usr/lib/hadoop/etc/hadoop/security/yarn.keytab yarn/`hostname -f`
