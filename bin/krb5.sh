#!/usr/bin/env bash
# run as root
# set up Kerberos server.
if [ $EUID != 0 ]; then
    echo "you must be root to run this."
    exit
fi

/etc/init.d/krb5kdc stop

yum -y install krb5-server

kdb5_util create -r HADOOP.LOCALDOMAIN -s

/etc/init.d/krb5kdc start


echo "modprinc -maxrenewlife 1week K/M@HADOOP.LOCALDOMAIN" | kadmin.local
echo "modprinc -maxrenewlife 1week krbtgt/HADOOP.LOCALDOMAIN@HADOOP.LOCALDOMAIN" | kadmin.local
