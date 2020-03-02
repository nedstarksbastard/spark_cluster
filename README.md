# spark_cluster

### Playbook
cd int the directory
`docker-compose up --scale spark-worker=3`

The compose file will pull **fiziy/spark** from docker hub which is used to create both master and worker nodes.
The image comes with
 
    - openjdk:8-alpine (Includes Java 8)
    - spark-2.4.5-bin-hadoop2.7 
    - python 3.7.6 

You can run this specific image as following:

`docker run --rm -it --name spark-master --hostname spark-master  -p 7077:7077 -p 8080:8080 fiziy/spark:latest /bin/sh`

This will open the bash shell inside the image, then

`/spark/bin/pyspark`

will give you the pyspark console where you can run python code


### Goal

I want to setup a standalone cluster using docker compose (done) and then connect to it locally 
(facing issues - please see this question - 
https://stackoverflow.com/questions/60442141/pythonconnect-to-a-spark-cluster-running-in-a-docker)

Then I want to add kafka and utilize Spark streaming