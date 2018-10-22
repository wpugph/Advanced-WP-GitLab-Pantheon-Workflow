#!/bin/bash

set -ex

npm install -g npm@latest
npm install -g gulp
npm install

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

rsync -rLvz --size-only --ipv4 --progress -e 'ssh -p 2222' ./$WPTHEME/. --temp-dir=~/tmp/ $ENV.$SITE@appserver.$ENV.$SITE.drush.in:code/$WPTHEME/ --exclude='*.git*' --exclude $THEMEEXCLUDE --exclude $THEMEEXCLUDEFILES

terminus env:commit --message $THEMEBUILDMSG --force -- $PANTHEONSITENAME.$ENV
terminus env:deploy --note $THEMEBUILDMSG -- $PANTHEONSITENAME.test

#terminus env:deploy --note "GitLab:$BUILDMSG" -- $PANTHEONSITENAME.test
