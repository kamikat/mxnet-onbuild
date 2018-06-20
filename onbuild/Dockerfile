ARG   BASE_IMAGE
FROM $BASE_IMAGE

# ONBUILD SCRIPTS

ONBUILD ARG NETRC_HOST
ONBUILD ARG NETRC_USERNAME
ONBUILD ARG NETRC_PASSWORD

ONBUILD COPY mxnet-build.conf /etc/mxnet-build.conf

ONBUILD RUN . /etc/mxnet-build.conf \
         && apt-get update \
         && apt-get install -y --no-install-recommends \
                    python-dev \
                    liblapack-dev \
                    libopenblas-dev \
                    libopencv-dev \
         && (test -n "$NETRC_HOST" \
             && echo "machine $NETRC_HOST" >> ~/.netrc \
             && echo "login $NETRC_USERNAME" >> ~/.netrc \
             && echo "password $NETRC_PASSWORD" >> ~/.netrc \
              ; true) \
         && cd /opt \
         && (test -n "$OPERATOR_URL" \
             && git clone $OPERATOR_URL --branch ${OPERATOR_BRANCH:-"master"} --depth 1 extra-operators \
             && MXNET_CONFIG="$MXNET_CONFIG EXTRA_OPERATORS=/opt/extra-operators" \
              ; true) \
         && git clone ${MXNET_URL:-"https://github.com/apache/incubator-mxnet.git"} --branch ${MXNET_BRANCH:-"master"} --depth 1 mxnet \
         && cd mxnet && git submodule update --init --recursive \
         && make -j $(nproc) USE_OPENCV=1 USE_BLAS=openblas USE_CUDA=1 USE_CUDA_PATH=/usr/local/cuda USE_CUDNN=1 $MXNET_CONFIG \
         && cd python && python setup.py install \
         && apt-get remove -y \
                    python-dev \
                    liblapack-dev \
                    libopenblas-dev \
                    libopencv-dev \
         && apt-get autoremove -y \
         && rm -rf /var/lib/apt/lists/* \
                   /opt/mxnet \
                   /opt/extra-operators \
                   ~/.netrc

