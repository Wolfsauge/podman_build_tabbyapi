#!/usr/bin/env bash

set -o pipefail

echo "Pod started.."

if [[ $PUBLIC_KEY ]]
then
  echo "Setting up SSH authorized_keys..."
  mkdir -p ~/.ssh
  echo "$PUBLIC_KEY" >> ~/.ssh/authorized_keys
  chmod 700 -R ~/.ssh
  ssh-keygen -v -l -f ~/.ssh/authorized_keys
fi

echo "Regenerating SSH host keys.."
rm -f /etc/ssh/ssh_host_* && \
  ssh-keygen -A

for SSH_HOST_PUB_KEY in /etc/ssh/ssh_host_*.pub
do
  echo "Host key: $SSH_HOST_PUB_KEY"
  ssh-keygen -lf $SSH_HOST_PUB_KEY
done

echo -e "\nexport PATH=\$PATH:/app" >> /root/.bashrc
service ssh start

# Deactivate the normal start script and replace it
chmod -v 644 /app/start.sh
mv -v /app/start.sh /app/_start.sh
ln -sfv /app/restart.sh /app/start.sh

# Move config.yml to the persistent storage
mv -v /app/config.yml /app/models
ln -sfv /app/models/config.yml /app/config.yml

echo "Starting tabbyAPI..."
/app/restart.sh

sleep infinity

