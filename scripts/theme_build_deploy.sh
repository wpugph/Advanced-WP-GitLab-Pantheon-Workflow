#!/bin/bash
# When PHPCS passes uncompiled, this process will compile your custom theme/plugin then compile them and push the compiled assets only to Pantheon
# TODO: minification process
set -ex

cd $ROOTPWD
ls
wget -qO- https://deb.nodesource.com/setup_10.x | -E bash -
apt-get install -y nodejs
# npm install -g npm@latest
# npm install -g gulp
# npm install

echo "This is where wp theme assets are built and deployed"
export THEMEBUILDMSG="GitLab WP theme build:$CI_COMMIT_MESSAGE"
export ENV=dev
export WPTHEME=web/wp-content/themes/twentyseventeen-child
export THEMEDEPLOYMSG="GitLab Theme deploy:$CI_COMMIT_MESSAGE"
export THEMEEXCLUDE="node_modules/ gulp/ source/"
export THEMEEXCLUDEFILES="*.json"

cd $ROOTPWD/$WPTHEME

terminus auth:login --machine-token=$MACHINETOKEN --email=$EMAIL
terminus connection:set $PANTHEONSITENAME.dev sftp

rsync -rLvz --size-only --ipv4 --progress -e 'ssh -p 2222' ./$WPTHEME/. --temp-dir=~/tmp/ $ENV.$SITE@appserver.$ENV.$SITE.drush.in:code/$WPTHEME/ --exclude='*.git*' --exclude node_modules/ --exclude gulp/ --exclude source/

terminus env:commit --message $THEMEBUILDMSG --force -- $PANTHEONSITENAME.$ENV
terminus env:deploy --note $THEMEBUILDMSG -- $PANTHEONSITENAME.test

#terminus env:deploy --note "GitLab:$BUILDMSG" -- $PANTHEONSITENAME.test
