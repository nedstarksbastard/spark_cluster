FROM openjdk:8-alpine

RUN apk --update add wget tar bash

# Get tars of spark and hadoop
RUN wget http://apache.mirror.anlx.net/spark/spark-2.4.5/spark-2.4.5-bin-hadoop2.7.tgz

RUN wget http://archive.apache.org/dist/hadoop/common/hadoop-2.7.7/hadoop-2.7.7.tar.gz

ARG SPARK_HOME='/spark'

ARG HADOOP_HOME='/hadoop'

# Install spark
RUN tar -xzf spark-2.4.5-bin-hadoop2.7.tgz && \
    mv spark-2.4.5-bin-hadoop2.7 /${SPARK_HOME} && \
    rm spark-2.4.5-bin-hadoop2.7.tgz

# Install hadoop
RUN tar -xzf hadoop-2.7.7.tar.gz && \
    mv hadoop-2.7.7 /${HADOOP_HOME} && \
    rm hadoop-2.7.7.tar.gz
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk/jre/" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh

ENV PATH $PATH:${HADOOP_HOME}/bin:${SPARK_HOME}/bin:${SPARK_HOME}/sbin

# Copy scripts for running spark master and slave
COPY run_master.sh /run_master.sh

COPY run_worker.sh /run_worker.sh

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
    build-base

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