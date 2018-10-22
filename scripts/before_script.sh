#!/bin/bash

# Exit immediately on errors, and echo commands as they are executed.
set -ex

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
ROOTPWD=`pwd`
# 'which ssh-agent || ( apt-get update -y && apt-get install openssh-client -y )'
mkdir -p ~/.ssh
eval $(ssh-agent -s)
# echo "[[ -f /.dockerenv ]]" > ~/.ssh/config
# echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config
# '[[ -f /.dockerenv ]] && echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config'
touch /root/.ssh/idrsa
echo "$STAGING_PRIVATE_KEY" > /root/.ssh/idrsa
chmod 400 /root/.ssh/idrsa
ssh-add /root/.ssh/idrsa
ssh-add -l
cd $ROOTPWD
php composer.phar install
composer global require consolidation/cgr
cgr --stability RC pantheon-systems/terminus
