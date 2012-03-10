#!/usr/bin/env bash                                                                         

adduser yarn
adduser mapred
adduser host
groupadd hadoop
groupadd supergroup

usermod -a -G hadoop hdfs
usermod -a -G hadoop yarn
usermod -a -G hadoop mapred
usermod -a -G supergroup host

