#!/usr/bin/env bash
# run as root
# set up Kerberos server.
if [ $EUID != 0 ]; then
    echo "you must be root to run this."
    exit
fi

/etc/init.d/krb5kdc stop

mv /etc/krb5.conf /etc/krb5.conf.save
cp etc/hadoop/krb5.conf /etc/

rm -rf /var/kerberos.save
mv /var/kerberos /var/kerberos.save

mkdir -m 755 -p /var/kerberos
chown root:root /var/kerberos
mkdir -m 755 -p /var/kerberos/krb5kdc
chown root:root /var/kerberos/krb5kdc

yum -y install krb5-server

cat etc/hadoop/krb5.conf | sed s/\\\${MASTER_HOST}/`hostname -f`/  > /etc/krb5.conf

kdb5_util create -r HADOOP.LOCALDOMAIN -s

cp etc/hadoop/kdc.conf  /var/kerberos/krb5kdc

/etc/init.d/krb5kdc start

echo "modprinc -maxrenewlife 1week K/M@HADOOP.LOCALDOMAIN" | kadmin.local
echo "modprinc -maxrenewlife 1week krbtgt/HADOOP.LOCALDOMAIN@HADOOP.LOCALDOMAIN" | kadmin.local
