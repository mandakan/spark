ARG PYTHON_TAG=3.8-slim-buster
ARG SPARK_VERSION_ARG
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

ARG EXTRA_PACKAGES=""
# Install JupyterLab and pyspark
RUN pip3 install --no-cache-dir --user \
  findspark \
  jupyterlab \
  pyspark \
  numpy \
  pandas \
  matplotlib \
  ${EXTRA_PACKAGES}

FROM fraktsedel/spark:${SPARK_VERSION_ARG}

COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''"]

ARG BUILD_DATE
LABEL BUILD_DATE=${BUILD_DATE}