ARG   BASE_IMAGE
FROM $BASE_IMAGE

# ONBUILD SCRIPTS

ONBUILD ARG MXNET_URL="https://github.com/apache/incubator-mxnet.git"
ONBUILD ARG MXNET_BRANCH="master"
ONBUILD ARG MXNET_CONFIG

ONBUILD ARG OPERATOR_URL
ONBUILD ARG OPERATOR_BRANCH="master"

ONBUILD ARG NETRC_HOST
ONBUILD ARG NETRC_USERNAME
ONBUILD ARG NETRC_PASSWORD

ONBUILD RUN apt-get update \
         && apt-get install -y --no-install-recommends \
                    python-dev \
                    liblapack-dev \
                    libopenblas-dev \
                    libopencv-dev \
         && cd /opt \
         && (test -n "$OPERATOR_URL" \
             && git clone $OPERATOR_URL --branch $OPERATOR_BRANCH --depth 1 extra-operators \
              ; true) \
         && (test -n "$NETRC_HOST" \
             && echo "machine $NETRC_HOST" >> ~/.netrc \
             && echo "login $NETRC_USERNAME" >> ~/.netrc \
             && echo "password $NETRC_PASSWORD" >> ~/.netrc \
              ; true) \
         && git clone $MXNET_URL --branch $MXNET_BRANCH --depth 1 mxnet \
         && cd mxnet && git submodule update --init --recursive \
         && make -j $(nproc) USE_OPENCV=1 USE_BLAS=openblas USE_CUDA=1 USE_CUDA_PATH=/usr/local/cuda USE_CUDNN=1 USE_DIST_KVSTORE=1 $MXNET_CONFIG \
         && cd python && python setup.py install \
         && apt-get remove -y \
                    python-dev \
                    liblapack-dev \
                    libopenblas-dev \
                    libopencv-dev \
         && apt-get autoremove -y \
         && rm -rf /var/lib/apt/lists/* \
                   /opt/mxnet \
                   ~/.netrc

