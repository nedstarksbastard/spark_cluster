FROM openjdk:8-alpine

RUN apk --update add wget tar bash

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
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk/jre/" >> hadoop/etc/hadoop/hadoop-env.sh

# add to PATH
ENV PATH $PATH:/hadoop/bin:/spark/bin:/spark/sbin

# copy configuration files
COPY ./conf/core-site.xml ./hadoop/etc/hadoop
COPY ./conf/yarn-site.xml ./hadoop/etc/hadoop
COPY ./conf/spark-defaults.conf ./spark/conf

# format the meta-data related to data-nodes - https://stackoverflow.com/questions/27143409/what-the-command-hadoop-namenode-format-will-do
RUN hadoop/bin/hdfs namenode -format

# Copy scripts for running spark master and slave
COPY scripts/run_master.sh /run_master.sh
COPY scripts/run_worker.sh /run_worker.sh

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
RUN pip install --upgrade pip && pyenv rehash

# Clean
RUN rm -rf ~/.cache/pip

RUN chmod +x /run_master.sh
RUN chmod +x /run_worker.sh