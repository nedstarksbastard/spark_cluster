#!/bin/sh

echo "Initializing SSH"
# quirk of alpine image. Using init.d service call does not work
/usr/sbin/sshd -e "$@" &

echo "Starting nodemanager"
/hadoop/sbin/yarn-daemon.sh start nodemanager &

echo "Starting Spark worker"
/spark/bin/spark-class org.apache.spark.deploy.worker.Worker \
    --webui-port $SPARK_WORKER_WEBUI_PORT \
    $SPARK_MASTER