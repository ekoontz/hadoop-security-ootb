#!/bin/sh
bin=`which $0`
bin=`dirname ${bin}`
bin=`cd "$bin"; pwd`

$bin/krb5.sh
$bin/setup-single-node.sh 
sudo $bin/permissions.sh 
$bin/runall-secure.sh
