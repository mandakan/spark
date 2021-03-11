#!/bin/bash

SPARK_VERSION=3.1.1
HADOOP_VERSION=3.2
PYTHON_TAG=3.8-slim-buster

docker buildx use multibuilder

docker buildx build \
--platform linux/amd64,linux/arm64 \
--build-arg PYTHON_TAG=$PYTHON_TAG \
--build-arg SPARK_VERSION_ARG=$SPARK_VERSION \
--build-arg HADOOP_VERSION_ARG=$HADOOP_VERSION \
--build-arg EXTRA_PACKAGES="" \
--build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
--tag fraktsedel/spark:latest \
--tag fraktsedel/spark:$SPARK_VERSION \
--push \
./spark

docker buildx build \
--platform linux/amd64,linux/arm64 \
--build-arg PYTHON_TAG=$PYTHON_TAG \
--build-arg SPARK_VERSION_ARG=$SPARK_VERSION \
--build-arg EXTRA_PACKAGES="" \
--build-arg EXTRA_DEPS="" \
--build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
--tag fraktsedel/jupyter-pyspark:latest \
--tag fraktsedel/jupyter-pyspark:$SPARK_VERSION \
--push \
./jupyter
