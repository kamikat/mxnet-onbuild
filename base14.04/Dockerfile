ARG CUDA_VERSION
ARG CUDNN_VERSION

FROM nvidia/cuda:${CUDA_VERSION}-cudnn${CUDNN_VERSION}-devel-ubuntu14.04

RUN rm -rf /etc/apt/sources.list.d/* \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
            git \
            wget \
            ca-certificates \
            graphviz \
            python-numpy \
            python-setuptools \
            python-opencv \
 && easy_install pip \
 && pip install setuptools \
                wheel \
                numpy \
 && rm -rf /var/lib/apt/lists/*

