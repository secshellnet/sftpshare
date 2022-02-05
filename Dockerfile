FROM alpine

RUN apk --update --no-cache add openssh-server openssh-sftp-server \
  && sed -i 's|#PermitRootLogin prohibit-password|PermitRootLogin no|' /etc/ssh/sshd_config \
  && sed -i 's|#PasswordAuthentication.*|PasswordAuthentication no|' /etc/ssh/sshd_config \
  && sed -i 's|#PubkeyAuthentication.*|PubkeyAuthentication yes|' /etc/ssh/sshd_config \
  && sed -i 's|AuthorizedKeysFile.*|AuthorizedKeysFile\t/etc/ssh/authorized_keys/%u|' /etc/ssh/sshd_config \
  \
  && mkdir -p /etc/ssh/keys/etc/ssh \
  && mkdir -p /etc/ssh/authorized_keys \
  && sed -i 's|#HostKey /etc/ssh/ssh_host_rsa_key*|HostKey /etc/ssh/keys/etc/ssh/ssh_host_rsa_key|' /etc/ssh/sshd_config \
  && sed -i 's|#HostKey /etc/ssh/ssh_host_ecdsa_key*|HostKey /etc/ssh/keys/etc/ssh/ssh_host_ecdsa_key|' /etc/ssh/sshd_config \
  && sed -i 's|#HostKey /etc/ssh/ssh_host_ed25519_key*|HostKey /etc/ssh/keys/etc/ssh/ssh_host_ed25519_key|' /etc/ssh/sshd_config \
  && sed -i '/ssh_host_ed25519_key/a HostKey \/etc\/ssh\/keys\/etc\/ssh\/ssh_host_dsa_key' /etc/ssh/sshd_config

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh
