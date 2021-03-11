ARG PYTHON_TAG=3.8-slim-buster
FROM python:$PYTHON_TAG AS builder
LABEL maintainer="m@thias.se"

# Install Requirements
ENV DEBIAN_FRONTEND=noninteractive
ARG EXTRA_DEPS=""
# Fix because folder missing in slim
RUN mkdir -p /usr/share/man/man1 \
 && apt-get update \
 && apt-get install -yq --no-install-recommends \
  build-essential \
  gcc \
  libffi-dev \
  ${EXTRA_DEPS} \
 && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --user \
  findspark \
  pyspark \
  numpy \
  pandas \
  matplotlib

ARG PYTHON_TAG=3.8-slim-buster
FROM python:$PYTHON_TAG
LABEL maintainer="m@thias.se"

# Install Requirements
ENV DEBIAN_FRONTEND=noninteractive
# Fix because folder missing in slim
RUN mkdir -p /usr/share/man/man1 \
 && apt-get update \
 && apt-get install -yq --no-install-recommends \
  build-essential \
  curl \
  openjdk-11-jre-headless \
  unzip \
 && rm -rf /var/lib/apt/lists/*

ARG SPARK_VERSION_ARG
ARG HADOOP_VERSION_ARG
# Install Spark
ENV SPARK_VERSION=${SPARK_VERSION_ARG}
ENV SPARK_PACKAGE=spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION_ARG}
ENV SPARK_HOME=/usr/spark-${SPARK_VERSION}
ENV PATH=$PATH:${SPARK_HOME}/bin
RUN curl -sL --retry 3 \
  "https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/${SPARK_PACKAGE}.tgz" \
  | gunzip \
  | tar x -C /usr/ \
 && mv /usr/$SPARK_PACKAGE $SPARK_HOME \
 && chown -R root:root $SPARK_HOME

COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH

EXPOSE 7077
EXPOSE 8080

WORKDIR $SPARK_HOME
CMD ["bin/spark-class", "org.apache.spark.deploy.master.Master"]

ARG BUILD_DATE
LABEL BUILD_DATE=${BUILD_DATE}