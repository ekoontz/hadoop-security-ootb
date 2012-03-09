#!/bin/sh
# run on master.
#TODO: add yarn support (not just hdfs)                                                            

if [ -z $SLAVE ]; then
    echo "you must define \$SLAVE in your environment."
    exit
fi


rm -f etc/host.slave.keytab
rm -f etc/hdfs.slave.keytab

echo "addprinc -randkey hdfs/$SLAVE" | kadmin.local
echo "addprinc -randkey host/$SLAVE" | kadmin.local
echo "ktadd -k etc/hdfs.slave.keytab hdfs/$SLAVE" | kadmin.local
echo "ktadd -k etc/host.slave.keytab host/$SLAVE" | kadmin.local

rm etc/merge.ktutil

cat > etc/merge.ktutil <<EOF 
rkt etc/hdfs.slave.keytab
rkt etc/host.slave.keytab
wkt etc/hdfs.slave.keytab
EOF

cat etc/merge.ktutil | ktutil

chown ec2-user etc/hdfs.slave.keytab
chmod 400 etc/hdfs.slave.keytab

# scp etc/hdfs.slave.keytab slave:/usr/lib/hadoop/etc/hadoop/security/hdfs.keytab
# on slave:
#cat hadoop-security-ootb/etc/hadoop/krb5.conf | perl -pe "s/\\\${MASTER_HOST}/$MASTER/g" > /etc/krb5.conf
