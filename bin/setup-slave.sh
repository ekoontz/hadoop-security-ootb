#!/usr/bin/env bash                                                                         
set -x
if [ -z $MASTER ]; then
    echo "you must define \$MASTER in your environment."
    exit
fi

if [ !-f /home/ec2-user/.ssh/ms-shared ]; then
    echo "you must have the master's private key in your environment so that the keytab may be fetched."
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
sudo scp -i /home/ec2-user/.ssh/ms-shared ec2-user@$MASTER:hadoop-security-ootb/etc/hdfs.slave.keytab /usr/lib/hadoop/etc/hadoop/security/hdfs.keytab

#test that keytab works.
set -x
kinit -k -t /usr/lib/hadoop/etc/hadoop/security/hdfs.keytab hdfs/`hostname -f`
