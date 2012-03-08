#!/bin/sh                                                                                                             
#TODO: add yarn support (not just hdfs)                                                                               

rm -f /tmp/host.slave.keytab
rm -f /tmp/hdfs.slave.keytab

echo "addprinc -randkey hdfs/$SLAVE" | kadmin.local
echo "addprinc -randkey host/$SLAVE" | kadmin.local
echo "ktadd -k /tmp/hdfs.slave.keytab hdfs/$SLAVE" | kadmin.local
echo "ktadd -k /tmp/host.slave.keytab host/$SLAVE" | kadmin.local

cat > /tmp/merge.ktutil <<EOF                                                                                         
rkt /tmp/hdfs.slave.keytab                                                                                            
rkt /tmp/host.slave.keytab                                                                                            
wkt /tmp/hdfs.slave.keytab                                                                                            
EOF                                                                                                                   

cat /tmp/merge.ktutil |	ktutil

chown ec2-user /tmp/hdfs.slave.keytab
chmod 400 /tmp/hdfs.slave.keytab



