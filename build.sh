#!/bin/bash

set -e

EXTRA_ARGS=$@

build_base_image() {
  IMAGE_NAME=${IMAGE_PREFIX:-""}mxnet-base:cu${1//./}-cudnn${2//./}-$3
  echo >&2 "Building $IMAGE_NAME..."
  docker build \
    --tag       $IMAGE_NAME \
                $EXTRA_ARGS \
    --build-arg CUDA_VERSION=$1 \
    --build-arg CUDNN_VERSION=$2 \
                base${OS_VERSION##ubuntu} 1>&2
  echo >&1 $IMAGE_NAME
}

build() {
  MXNET_VERSION=${1:-master}
  CUDA_VERSION=${2:-8.0}
  CUDNN_VERSION=${3:-5}
  OS_VERSION=${4:-ubuntu14.04}
  IMAGE_NAME=${IMAGE_PREFIX:-""}mxnet-onbuild:${MXNET_VERSION}-cu${CUDA_VERSION//./}-cudnn${CUDNN_VERSION//./}-${OS_VERSION}
  BASE_IMAGE=$(build_base_image $CUDA_VERSION $CUDNN_VERSION $OS_VERSION)
  echo >&2 "Building $IMAGE_NAME..."
  docker build \
    --tag       $IMAGE_NAME \
                $EXTRA_ARGS \
    --build-arg BASE_IMAGE=$BASE_IMAGE \
    --build-arg MXNET_VERSION=$MXNET_VERSION \
                onbuild
}

if [ "$CI_BUILD" == "1" -a -z "$TARGET" ]; then
  echo >&2 "Variable TARGET is not set for CI builds."
  exit 1
fi

build_batch() {
  build master $@
  build 0.12.0 $@
  build 0.11.0 $@
  build  1.0.0 $@
  if [ "$CI_BUILD" == "1" ]; then
    docker push ${IMAGE_PREFIX:-""}mxnet-onbuild
    docker images ${IMAGE_PREFIX:-""}mxnet-onbuild -q | xargs docker rmi
    docker images ${IMAGE_PREFIX:-""}mxnet-base -q | xargs docker rmi
    docker images -q | xargs docker rmi
  fi
}

[ -z "$TARGET" -o "$TARGET" == "cu9x" ] && build_batch 9.1 7 ubuntu16.04
[ -z "$TARGET" -o "$TARGET" == "cu9x" ] && build_batch 9.0 7 ubuntu16.04
[ -z "$TARGET" -o "$TARGET" == "cu80" ] && build_batch 8.0 7 ubuntu16.04
[ -z "$TARGET" -o "$TARGET" == "cu80" ] && build_batch 8.0 6 ubuntu16.04
[ -z "$TARGET" -o "$TARGET" == "cu80" ] && build_batch 8.0 5 ubuntu16.04
[ -z "$TARGET" -o "$TARGET" == "cu80" ] && build_batch 8.0 7
[ -z "$TARGET" -o "$TARGET" == "cu80" ] && build_batch 8.0 6
[ -z "$TARGET" -o "$TARGET" == "cu80" ] && build_batch 8.0 5
[ -z "$TARGET" -o "$TARGET" == "cu75" ] && build_batch 7.5 6
[ -z "$TARGET" -o "$TARGET" == "cu75" ] && build_batch 7.5 5
[ -z "$TARGET" -o "$TARGET" == "cu75" ] && build_batch 7.5 4
[ -z "$TARGET" -o "$TARGET" == "cu75" ] && build_batch 7.5 3
[ -z "$TARGET" -o "$TARGET" == "cu70" ] && build_batch 7.0 4
[ -z "$TARGET" -o "$TARGET" == "cu70" ] && build_batch 7.0 3
[ -z "$TARGET" -o "$TARGET" == "cu70" ] && build_batch 7.0 2
