FROM openjdk:8-alpine

USER root

# Getting coreutils to use no-hup to start spark daemons later on.
# Don't have to but makes life easier.
# wget, tar, bash for getting spark and hadoopFizi
RUN apk --update add coreutils wget tar bash

# Get tars of spark and hadoop
RUN wget http://apache.mirror.anlx.net/spark/spark-2.4.5/spark-2.4.5-bin-hadoop2.7.tgz
RUN wget http://archive.apache.org/dist/hadoop/common/hadoop-2.7.7/hadoop-2.7.7.tar.gz

# Install spark
RUN tar -xzf spark-2.4.5-bin-hadoop2.7.tgz && \
    mv spark-2.4.5-bin-hadoop2.7 /spark && \
    rm spark-2.4.5-bin-hadoop2.7.tgz

# Install hadoop
RUN tar -xzf hadoop-2.7.7.tar.gz && \
    mv hadoop-2.7.7 /hadoop && \
    rm hadoop-2.7.7.tar.gz
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk/jre/" >> /hadoop/etc/hadoop/hadoop-env.sh

# add to PATH
ENV PATH $PATH:/hadoop/bin:/spark/bin:/spark/sbin

ENV HADOOP_HOME /hadoop
ENV HADOOP_CONF_DIR=/hadoop/etc/hadoop
ENV SPARK_HOME /spark


# format the meta-data related to data-nodes - https://stackoverflow.com/questions/27143409/what-the-command-hadoop-namenode-format-will-do
RUN hadoop/bin/hdfs namenode -format

# Install components for Python
RUN apk add --no-cache --update \
    git \
    libffi-dev \
    openssl-dev \
    zlib-dev \
    bzip2-dev \
    readline-dev \
    sqlite-dev \
    musl \
    libc6-compat \
    linux-headers \
    build-base \
    procps \
    ca-certificates\
    openssh \
    openrc

RUN rc-update add sshd

# Set Python version
ARG PYTHON_VERSION='3.7.6'
# Set pyenv home
ARG PYENV_HOME=/root/.pyenv

# Install pyenv, then install python version
RUN git clone --depth 1 https://github.com/pyenv/pyenv.git $PYENV_HOME && \
    rm -rfv $PYENV_HOME/.git

ENV PATH $PYENV_HOME/shims:$PYENV_HOME/bin:$PATH

RUN pyenv install $PYTHON_VERSION
RUN pyenv global $PYTHON_VERSION
RUN pip install --upgrade pip setuptools wheel && pyenv rehash
RUN pip install pyspark
# Clean
RUN rm -rf ~/.cache/pip

# copy configuration files
COPY ./conf/core-site.xml ./hadoop/etc/hadoop
COPY ./conf/yarn-site.xml ./hadoop/etc/hadoop
COPY ./conf/spark-defaults.conf ./spark/conf

# Copy scripts for running spark master and slave
COPY scripts/run_master.sh /run_master.sh
COPY scripts/run_worker.sh /run_worker.sh

RUN chmod +x /run_master.sh
RUN chmod +x /run_worker.sh

RUN sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config && \
    echo "root:root" | chpasswd

# Create SSH key for passwordless access
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
  chmod 600 ~/.ssh/authorized_keys

RUN ssh-keygen -A

# node manager ports

EXPOSE 22
EXPOSE 50010 50020 50070 50075 50090 8020 9000
EXPOSE 10020 19888
EXPOSE 8030 8031 8032 8033 8040 8042 8088
EXPOSE 49707 2122 7001 7002 7003 7004 7005 7006 7007 8888 9000