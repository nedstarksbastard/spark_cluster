#!/bin/sh

echo "Initializing SSH"
sudo service ssh start

echo "Starting nodemanager"
/hadoop/sbin/yarn-daemon.sh start nodemanager &

echo "Starting Spark worker"
/spark/bin/spark-class org.apache.spark.deploy.worker.Worker \
    --webui-port $SPARK_WORKER_WEBUI_PORT \
    $SPARK_MASTER