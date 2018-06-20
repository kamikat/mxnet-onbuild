# mxnet-onbuild

This repository builds onbuild images for MXNet environment with Python 2.7.

## Usage

Edit `mxnet-build.conf`:

```bash
# mxnet-onbuild configuration file
#
#     build docker images of mxnet and python 2.7
#

# The options below define how the mxnet is built.
# Place this file in build context with Dockerfile
# which builds upon mxnet-onbuild image.

# git repository address of mxnet
MXNET_URL="https://github.com/apache/incubator-mxnet.git"

# branch/tag to build with
MXNET_BRANCH="master"

# mxnet options
# (see https://github.com/apache/incubator-mxnet/blob/master/make/config.mk)
MXNET_CONFIG="USE_DIST_KVSTORE=1"

# git repository address of extra mxnet operators
# this option also sets EXTRA_OPERATORS option of mxnet.
#OPERATOR_URL=

# branch/tag of operator repository
#OPERATOR_BRANCH="master"
```

Create new Dockerfile:

```dockerfile
FROM kamikat/mxnet-onbuild:cu80-cudnn5-ubuntu14.04

# ...
```

Build without authentication:

```
docker build -t <tag> <context>
```

Build with authentication (private repository):

```
docker build . \
  --build-arg NETRC_HOST=<hostname> \
  --build-arg NETRC_USERNAME=<username> \
  --build-arg NETRC_PASSWORD=<password> \
  --tag <tag> \
```

**(Optional)** build with compose file:

```yaml
services:
  sshd:
    build:
      context: .
      args:
        - NETRC_HOST
        - NETRC_USERNAME
        - NETRC_PASSWORD
    # ...
```

### Example: SSH service

```dockerfile
FROM kamikat/mxnet-onbuild:cu80-cudnn5-ubuntu14.04

RUN apt-get update \
 && apt-get install -y --no-install-recommends openssh-server \
 && mkdir /var/run/sshd \
 && (echo 'root:root' | chpasswd) \
 && sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
 && sed -i 's/Port 22/Port 2222/' /etc/ssh/sshd_config \
 && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
 && echo "export VISIBLE=now" >> /etc/profile

ENV NOTVISIBLE "in users profile"

EXPOSE 2222

CMD ["/usr/sbin/sshd", "-D"]
```

## License

(The MIT License)
