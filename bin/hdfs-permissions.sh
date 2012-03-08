bin=`which $0`
bin=`dirname ${bin}`
bin=`cd "$bin"; pwd`

kinit -k -t $bin/../etc/hadoop/security/hdfs.keytab hdfs/`hostname -f`@HADOOP.LOCALDOMAIN
kinit -R

$bin/hadoop fs -chmod 755 hdfs://`hostname -f`:9000/

$bin/hadoop fs -mkdir hdfs://`hostname -f`:9000/tmp
$bin/hadoop fs -chown hdfs:hadoop hdfs://`hostname -f`:9000/tmp
$bin/hadoop fs -chmod 777 hdfs://`hostname -f`:9000/tmp # ('t')?

$bin/hadoop fs -mkdir hdfs://`hostname -f`:9000/user
$bin/hadoop fs -chown hdfs:hadoop hdfs://`hostname -f`:9000/user
$bin/hadoop fs -chmod 775 hdfs://`hostname -f`:9000/user

$bin/hadoop fs -mkdir hdfs://`hostname -f`:9000/yarn
$bin/hadoop fs -chown yarn:hadoop hdfs://`hostname -f`:9000/yarn/
$bin/hadoop fs -chmod 777 hdfs://`hostname -f`:9000/yarn/ # ('t')?

#do we need both /yarn and /tmp/yarn ?
$bin/hadoop fs -mkdir hdfs://`hostname -f`:9000/tmp/yarn
$bin/hadoop fs -chown yarn:hadoop hdfs://`hostname -f`:9000/tmp/yarn/
$bin/hadoop fs -chmod 777 hdfs://`hostname -f`:9000/tmp/yarn/ # ('t')?


$bin/hadoop fs -mkdir hdfs://`hostname -f`:9000/mapred

$bin/hadoop fs -mkdir hdfs://`hostname -f`:9000/mapred/intermediate
$bin/hadoop fs -chown mapred:hadoop hdfs://`hostname -f`:9000/mapred/intermediate
$bin/hadoop fs -chmod 777 hdfs://`hostname -f`:9000/mapred/intermediate

$bin/hadoop fs -mkdir hdfs://`hostname -f`:9000/mapred/done
$bin/hadoop fs -chown mapred:hadoop hdfs://`hostname -f`:9000/mapred/done
$bin/hadoop fs -chmod 750 hdfs://`hostname -f`:9000/mapred/done


#dump the contents for verification.
$bin/hadoop fs -ls -R hdfs://`hostname -f`:9000/
