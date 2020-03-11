#!/bin/sh

echo "Initializing SSH"
# quirk of alpine image. Using init.d service call does not work
/usr/sbin/sshd -e "$@" &

#ssh-agent is a background priocess that handles passwords for ssh private keys
eval `ssh-agent -s`
# ssh-add command prompts the user for a private key password and
# adds it to the list maintained by ssh-agent
exec ssh-add &

# Below 3 lines will hide the prompt about fingerprinting during ssh connection to HDFS
ssh -oStrictHostKeyChecking=no spark-master uptime
ssh -oStrictHostKeyChecking=no localhost uptime
ssh -oStrictHostKeyChecking=no 0.0.0.0 uptime

echo "Starting HDFS"
/hadoop/sbin/start-dfs.sh > ./start-dfs.log

# Now, start YARN resource manager and redirect output to the logs
echo "Starting YARN resource manager"
yarn resourcemanager > ~/resourcemanager.log 2>&1 &

echo "Starting history server"
hdfs dfs -mkdir /shared
hdfs dfs -mkdir /shared/spark-logs
./spark/sbin/start-history-server.sh &

echo "Starting Spark master"
/spark/bin/spark-class org.apache.spark.deploy.master.Master \
    --ip $SPARK_LOCAL_IP \
    --port $SPARK_MASTER_PORT \
    --webui-port $SPARK_MASTER_WEBUI_PORT