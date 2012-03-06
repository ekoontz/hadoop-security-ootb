#!/usr/bin/env bash
# run as root
# idempotent: can be run repeatedly with a consistent end state.
bin=/home/ec2-user/hadoop-runtime/bin

REALM=HADOOP.LOCALDOMAIN
KEYTAB_DIR=/home/ec2-user/hadoop-runtime/etc/hadoop/security
HOST=`hostname -f`

#Part 1: users,groups, and principals.

adduser hdfs
adduser yarn
adduser mapred

groupadd hadoop

usermod -a -G hadoop hdfs
usermod -a -G hadoop yarn
usermod -a -G hadoop mapred

mkdir -m 700 /tmp/hadoop-nn
mkdir -m 700 /tmp/hdfs-nn
mkdir -m 700 /tmp/hdfs-dn
mkdir -m 775 /tmp/hdfs-log
chown hdfs:hadoop /tmp/hdfs-nn /tmp/hdfs-dn /tmp/hdfs-log

mkdir -m 775 /tmp/yarn-log
mkdir -m 755 /tmp/yarn-nm-local
mkdir -m 755 /tmp/yarn-nm-log
chown yarn:hadoop /tmp/yarn-log /tmp/yarn-nm-local /tmp/yarn-nm-log

mkdir -m 700 -p $KEYTAB_DIR
chown hdfs:hadoop $KEYTAB_DIR

echo "delprinc -force host/$HOST@$REALM"  | kadmin.local
echo "delprinc -force   nn/$HOST@$REALM"  | kadmin.local
echo "delprinc -force   sn/$HOST@$REALM"  | kadmin.local
echo "delprinc -force   dn/$HOST@$REALM"  | kadmin.local
echo "delprinc -force  wap/$HOST@$REALM"  | kadmin.local
echo "delprinc -force   rm/$HOST@$REALM"  | kadmin.local
echo "delprinc -force   nm/$HOST@$REALM"  | kadmin.local
echo "delprinc -force  jhs/$HOST@$REALM"  | kadmin.local

echo "addprinc -randkey host/$HOST@$REALM"  | kadmin.local
echo "addprinc -randkey   nn/$HOST@$REALM"  | kadmin.local
echo "addprinc -randkey   sn/$HOST@$REALM"  | kadmin.local
echo "addprinc -randkey   dn/$HOST@$REALM"  | kadmin.local
echo "addprinc -randkey  wap/$HOST@$REALM"  | kadmin.local
echo "addprinc -randkey   rm/$HOST@$REALM"  | kadmin.local
echo "addprinc -randkey   nm/$HOST@$REALM"  | kadmin.local
echo "addprinc -randkey  jhs/$HOST@$REALM"  | kadmin.local

echo "modprinc -maxrenewlife 1hour       host/$HOST@$REALM" | kadmin.local
echo "modprinc -maxrenewlife 1hour         nn/$HOST@$REALM" | kadmin.local
echo "modprinc -maxrenewlife 1hour         sn/$HOST@$REALM" | kadmin.local
echo "modprinc -maxrenewlife 1hour         dn/$HOST@$REALM" | kadmin.local
echo "modprinc -maxrenewlife 1hour        wap/$HOST@$REALM" | kadmin.local
echo "modprinc -maxrenewlife 1hour         rm/$HOST@$REALM" | kadmin.local
echo "modprinc -maxrenewlife 1hour         nm/$HOST@$REALM" | kadmin.local
echo "modprinc -maxrenewlife 1hour        jhs/$HOST@$REALM" | kadmin.local


#Part 2: keytabs
#throw out existing hadoop keytab files, if any
rm -f $KEYTAB_DIR/host.keytab $KEYTAB_DIR/nn.keytab $KEYTAB_DIR/sn.keytab \
      $KEYTAB_DIR/dn.keytab $KEYTAB_DIR/wap.keytab \
      $KEYTAB_DIR/rm.keytab $KEYTAB_DIR/nm.keytab \
      $KEYTAB_DIR/jhs.keytab

echo "ktadd -k $KEYTAB_DIR/host.keytab host/$HOST@$REALM" | kadmin.local
echo "ktadd -k $KEYTAB_DIR/nn.keytab nn/$HOST@$REALM"     | kadmin.local
echo "ktadd -k $KEYTAB_DIR/sn.keytab sn/$HOST@$REALM"     | kadmin.local
echo "ktadd -k $KEYTAB_DIR/dn.keytab dn/$HOST@$REALM"     | kadmin.local
echo "ktadd -k $KEYTAB_DIR/wap.keytab wap/$HOST@$REALM"   | kadmin.local
echo "ktadd -k $KEYTAB_DIR/rm.keytab rm/$HOST@$REALM"     | kadmin.local
echo "ktadd -k $KEYTAB_DIR/nm.keytab nm/$HOST@$REALM"     | kadmin.local
echo "ktadd -k $KEYTAB_DIR/jhs.keytab jhs/$HOST@$REALM"   | kadmin.local

cat $bin/merge.ktutil | perl -pe "s|_KEYTAB_DIR|$KEYTAB_DIR|g" | ktutil

chown hdfs:hadoop $KEYTAB_DIR/host.keytab \
$KEYTAB_DIR/nn.keytab $KEYTAB_DIR/sn.keytab $KEYTAB_DIR/dn.keytab \
$KEYTAB_DIR/wap.keytab \
$KEYTAB_DIR/rm.keytab $KEYTAB_DIR/nm.keytab $KEYTAB_DIR/jhs.keytab 

chmod 660 $KEYTAB_DIR/host.keytab \
$KEYTAB_DIR/nn.keytab $KEYTAB_DIR/sn.keytab $KEYTAB_DIR/dn.keytab \
$KEYTAB_DIR/wap.keytab \
$KEYTAB_DIR/rm.keytab $KEYTAB_DIR/nm.keytab $KEYTAB_DIR/jhs.keytab

