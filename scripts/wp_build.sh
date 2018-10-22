#!/bin/bash

set -ex

echo "This is where wp core and plugins are built and deployed"
export ENV=dev
ls
pwd
terminus auth:login --machine-token=$MACHINETOKEN --email=$EMAIL
terminus connection:set $PANTHEONSITENAME.dev sftp
rsync -Lvz --size-only --ipv4 -a --delete --progress -e 'ssh -p 2222' ./. --temp-dir=~/tmp/ $ENV.$SITE@appserver.$ENV.$SITE.drush.in:code/ --exclude=".git*"
rsync -Lvz --size-only --ipv4 -a --delete --progress -e 'ssh -p 2222' ./web/. --temp-dir=~/tmp/ $ENV.$SITE@appserver.$ENV.$SITE.drush.in:code/web/ --exclude=".git*"
rsync -Lvz --size-only --ipv4 -a --delete --progress -e 'ssh -p 2222' ./vendor/. --temp-dir=~/tmp/ $ENV.$SITE@appserver.$ENV.$SITE.drush.in:code/vendor/ --exclude=".git*"
rsync -rLvz --size-only --ipv4 --progress -e 'ssh -p 2222' ./web/. --temp-dir=~/tmp/ $ENV.$SITE@appserver.$ENV.$SITE.drush.in:code/web/ --exclude=".git*"
rsync -rLvz --size-only --ipv4 --progress -e 'ssh -p 2222' ./vendor/composer/. --temp-dir=~/tmp/ $ENV.$SITE@appserver.$ENV.$SITE.drush.in:code/vendor/composer/ --exclude=".git*"
rsync -rLvz --size-only --ipv4 --progress -e 'ssh -p 2222' ./vendor/johnpbloch/. --temp-dir=~/tmp/ $ENV.$SITE@appserver.$ENV.$SITE.drush.in:code/vendor/johnpbloch/ --exclude=".git*"
echo $CI_COMMIT_MESSAGE
terminus env:commit --message "GitLab:$CI_COMMIT_MESSAGE" --force -- $PANTHEONSITENAME.$ENV
terminus env:deploy --note "GitLab:$CI_COMMIT_MESSAGE" -- $PANTHEONSITENAME.test
