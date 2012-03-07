#!/usr/bin/env bash
# no historymanager or secondary namenode yet.
bin=`which $0`
bin=`dirname ${bin}`
bin=`cd "$bin"; pwd`

$bin/start-hdfs.sh
$bin/start-yarn.sh

#get sudo permission from user, if necessary: 'echo' is just an inoccuous thing to run to get the necessary permission.
sudo echo 

#finally, set permissions.
#first, set up credentials so that we have nn's permission to modify HDFS.
kinit -k -t $bin/../etc/hadoop/security/nn.keytab nn/`hostname -f`@HADOOP.LOCALDOMAIN
kinit -R

bin/hadoop fs -chmod 755 hdfs://`hostname -f`:9000/

bin/hadoop fs -mkdir hdfs://`hostname -f`:9000/tmp
bin/hadoop fs -chown hdfs:hadoop hdfs://`hostname -f`:9000/tmp
bin/hadoop fs -chmod 777 hdfs://`hostname -f`:9000/tmp # ('t')?

bin/hadoop fs -mkdir hdfs://`hostname -f`:9000/user
bin/hadoop fs -chown hdfs:hadoop hdfs://`hostname -f`:9000/user
bin/hadoop fs -chmod 775 hdfs://`hostname -f`:9000/user

bin/hadoop fs -mkdir hdfs://`hostname -f`:9000/yarn
bin/hadoop fs -chown yarn:hadoop hdfs://`hostname -f`:9000/yarn/
bin/hadoop fs -chmod 777 hdfs://`hostname -f`:9000/yarn/ # ('t')?

#do we need both /yarn and /tmp/yarn ?
bin/hadoop fs -mkdir hdfs://`hostname -f`:9000/tmp/yarn
bin/hadoop fs -chown yarn:hadoop hdfs://`hostname -f`:9000/tmp/yarn/
bin/hadoop fs -chmod 777 hdfs://`hostname -f`:9000/tmp/yarn/ # ('t')?


bin/hadoop fs -mkdir hdfs://`hostname -f`:9000/mapred

bin/hadoop fs -mkdir hdfs://`hostname -f`:9000/mapred/intermediate
bin/hadoop fs -chown mapred:hadoop hdfs://`hostname -f`:9000/mapred/intermediate
bin/hadoop fs -chmod 777 hdfs://`hostname -f`:9000/mapred/intermediate

bin/hadoop fs -mkdir hdfs://`hostname -f`:9000/mapred/done
bin/hadoop fs -chown mapred:hadoop hdfs://`hostname -f`:9000/mapred/done
bin/hadoop fs -chmod 750 hdfs://`hostname -f`:9000/mapred/done


#dump the contents for diagnostics.
bin/hadoop fs -ls -R hdfs://`hostname -f`:9000/

sudo mkdir /tmp/hadoop/tmp
sudo chown -R hdfs:hadoop /tmp/hadoop/tmp
sudo chmod -R 775 /tmp/hadoop/tmp
