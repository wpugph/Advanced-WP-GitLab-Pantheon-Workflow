#!/bin/bash

set -ex

echo "This is where wp theme assets are built and deployed"
cd $ROOTPWD
export ENV=dev
export WPTHEME=web/wp-content/themes/twentyseventeen-child
export THEMEDEPLOYMSG="GitLab Theme deploy:$CI_COMMIT_MESSAGE"
export THEMEEXCLUDE="'*.git*' node_modules/ gulp/"
terminus auth:login --machine-token=$MACHINETOKEN --email=$EMAIL
terminus connection:set $PANTHEONSITENAME.dev sftp

rsync -rLvz --size-only --ipv4 --progress -e 'ssh -p 2222' ./$WPTHEME/. --temp-dir=~/tmp/ $ENV.$SITE@appserver.$ENV.$SITE.drush.in:code/$WPTHEME/ --exclude=$THEMEEXCLUDE

echo $CI_COMMIT_MESSAGE
terminus env:commit --message $THEMEDEPLOYMSG --force -- $PANTHEONSITENAME.$ENV
terminus env:deploy --note $THEMEDEPLOYMSG -- $PANTHEONSITENAME.test
