#!/bin/sh

echo "Starting HDFS"
/hadoop/sbin/start-dfs.sh > ./start-dfs.log

# Now, start YARN resource manager and redirect output to the logs
echo "Starting YARN resource manager"
yarn resourcemanager > ~/resourcemanager.log 2>&1 &

echo "Starting history server"
hdfs dfs -mkdir /shared
hdfs dfs -mkdir /shared/spark-logs
/spark/sbin/start-history-server.sh &

echo "Starting Spark master"
/spark/bin/spark-class org.apache.spark.deploy.master.Master \
    --ip $SPARK_LOCAL_IP \
    --port $SPARK_MASTER_PORT \
    --webui-port $SPARK_MASTER_WEBUI_PORT