ARG   BASE_IMAGE
FROM $BASE_IMAGE

# ONBUILD SCRIPTS

ARG MXNET_VERSION
ENV MXNET_VERSION $MXNET_VERSION

ONBUILD COPY mxnet_mod /opt/mxnet_mod
ONBUILD  RUN cd /root \
          && git clone --recursive https://github.com/apache/incubator-mxnet.git --branch $MXNET_VERSION mxnet \
          && cd /root/mxnet \
          && tar cf - /opt/mxnet_mod 2>/dev/null | tar xf - --strip-components=1 --no-overwrite-dir \
          && make -j $(nproc) USE_OPENCV=1 USE_BLAS=openblas USE_CUDA=1 USE_CUDA_PATH=/usr/local/cuda USE_CUDNN=1 USE_DIST_KVSTORE=1 \
          && cd /root/mxnet/python \
          && python setup.py install \
          && cd /root && rm -rf mxnet mxnet_mod

ONBUILD EXPOSE 2222

ONBUILD CMD ["/usr/sbin/sshd", "-D"]
