# SFTP Share

This image provides a sftp jail which can be deployed using docker.

## Deployment

The environment variable `USERS` controlls which users are allowed to connect to the SSH server.
Remember to put your ssh public keys in `/srv/share/authorized_keys/<username>`.

### Docker
```sh
sudo docker run --rm -it \
  -e "USERS=nico" \
  -v "/srv/share/keys/:/etc/ssh/keys/etc/ssh/" \
  -v "/srv/share/authorized_keys/:/etc/ssh/authorized_keys/" \
  -v "/srv/share/home/:/home/" \
  ghcr.io/secshellnet/sftpshare
```

### docker-compose
```yml
version: '3.9'

services:
  share:
    image: ghcr.io/secshellnet/sftpshare
    restart: always
    environment:
      - "USERS=nico"
    volumes:
      - "/srv/share/keys/:/etc/ssh/keys/etc/ssh/"
      - "/srv/share/authorized_keys/:/etc/ssh/authorized_keys/"
      - "/srv/share/home/:/home/"
    ports:
      - "2222:22"
```

