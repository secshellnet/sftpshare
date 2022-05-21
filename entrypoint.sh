#!/bin/sh

if [ -z ${USERS} ]; then
    echo "Error: No user specified. You need to set the environment variable USERS to a comma seperated list of users. e.g. USERS=jane,john"
    exit 1
fi

# generate ssh keys if they does not exist
ssh-keygen -A -f /etc/ssh/keys

# change permissions of authorized keys
find /etc/ssh/authorized_keys/ -type f -exec chmod 644 {} \;

# add users
IFS=','
for user in ${USERS}; do
    adduser --shell=/bin/false --disabled-password ${user}
    passwd -u ${user} &> /dev/null
    chmod o-r /home/${user}

    if [ ! -f /etc/ssh/authorized_keys/${user} ]; then
        echo "Warning: Unable to locate public ssh key for user ${user}!"
    fi

    if ! grep "Match User ${user}" /etc/ssh/sshd_config > /dev/null; then
      cat <<_EOF >> /etc/ssh/sshd_config
Match User ${user}
   ChrootDirectory /home
   ForceCommand internal-sftp -d /${user}
_EOF
    fi
done

/usr/sbin/sshd -eD
