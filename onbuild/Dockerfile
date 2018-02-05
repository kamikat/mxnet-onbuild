ARG   BASE_IMAGE
FROM $BASE_IMAGE

# ONBUILD SCRIPTS

ARG MXNET_VERSION
ENV MXNET_VERSION $MXNET_VERSION

ONBUILD COPY mxnet_mod /opt/mxnet_mod
ONBUILD  ARG MXNET_VERSION_OVERRIDE
ONBUILD  RUN cd /opt \
          && git clone https://github.com/apache/incubator-mxnet.git --branch $MXNET_VERSION mxnet && cd mxnet \
          && git checkout ${MXNET_VERSION_OVERRIDE:-$MXNET_VERSION} \
          && git submodule update --init --recursive \
          && tar cf - /opt/mxnet_mod 2>/dev/null | tar xf - --strip-components=1 --no-overwrite-dir \
          && make -j $(nproc) USE_OPENCV=1 USE_BLAS=openblas USE_CUDA=1 USE_CUDA_PATH=/usr/local/cuda USE_CUDNN=1 USE_DIST_KVSTORE=1 \
          && cd python && python setup.py install \
          && cd /opt && rm -rf mxnet mxnet_mod

ONBUILD EXPOSE 2222

ONBUILD CMD ["/usr/sbin/sshd", "-D"]
