#!/bin/sh
bin=`which $0`
bin=`dirname ${bin}`
bin=`cd "$bin"; pwd`

sudo $bin/krb5.sh
$bin/setup-single-node.sh 
sudo $bin/permissions.sh 



