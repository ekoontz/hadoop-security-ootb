#!/bin/sh
# run on master as:
# $ sudo su - -c "SLAVE=$SLAVE /home/ec2-user/hadoop-security-ootb/bin/slave-keytabs.sh "
set -x
if [ -z $SLAVE ]; then
    echo "you must define \$SLAVE in your environment."
    exit 1
fi

bin=`which $0`
bin=`dirname ${bin}`
bin=`cd "$bin"; pwd`

cd $bin/..

rm -f etc/host.slave.keytab
rm -f etc/hdfs.slave.keytab
rm -f etc/yarn.slave.keytab

echo "addprinc -randkey hdfs/$SLAVE" | kadmin.local
echo "addprinc -randkey yarn/$SLAVE" | kadmin.local
echo "addprinc -randkey host/$SLAVE" | kadmin.local
echo "ktadd -k etc/hdfs.slave.keytab hdfs/$SLAVE" | kadmin.local
echo "ktadd -k etc/yarn.slave.keytab yarn/$SLAVE" | kadmin.local
echo "ktadd -k etc/host.slave.keytab host/$SLAVE" | kadmin.local

rm etc/merge.ktutil

cat > etc/merge.ktutil <<EOF 
rkt etc/hdfs.slave.keytab
rkt etc/host.slave.keytab
wkt etc/hdfs.slave.keytab
EOF

cat etc/merge.ktutil | ktutil


cat > etc/merge.ktutil <<EOF 
rkt etc/yarn.slave.keytab
rkt etc/host.slave.keytab
wkt etc/yarn.slave.keytab
EOF

cat etc/merge.ktutil | ktutil

chown ec2-user etc/hdfs.slave.keytab
chmod 400 etc/hdfs.slave.keytab

chown ec2-user etc/yarn.slave.keytab
chmod 400 etc/yarn.slave.keytab


