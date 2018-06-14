ARG   BASE_IMAGE
FROM $BASE_IMAGE

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
