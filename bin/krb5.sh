#!/usr/bin/env bash
# run as root
yum -y install krb5-server
kdb5_util create -s
/etc/init.d/krb5kdc start

echo "modprinc -maxrenewlife 1week K/M@HADOOP.LOCALDOMAIN" | kadmin.local
echo "modprinc -maxrenewlife 1week krbtgt/HADOOP.LOCALDOMAIN@HADOOP.LOCALDOMAIN" | kadmin.local
