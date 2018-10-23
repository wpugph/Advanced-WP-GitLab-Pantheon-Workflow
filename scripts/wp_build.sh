#!/bin/bash
# When PHPCS pass, this will build your composer assets for wp core and plugins and deploy it to Pantheon, you can skip this part if there are no changed in plugins and core
set -ex

export BUILDMSG="GitLab WP build:$CI_COMMIT_MESSAGE"
export ENV=dev

terminus auth:login --machine-token=$MACHINETOKEN --email=$EMAIL
terminus connection:set $PANTHEONSITENAME.dev sftp

rsync -Lvz --ipv4 -a --delete --progress -e 'ssh -p 2222' ./. --temp-dir=~/tmp/ $ENV.$SITE@appserver.$ENV.$SITE.drush.in:code/ --exclude *.git* --exclude scripts/ --exclude vendor/

rsync -Lvz --size-only --ipv4 -a --delete --progress -e 'ssh -p 2222' ./web/. --temp-dir=~/tmp/ $ENV.$SITE@appserver.$ENV.$SITE.drush.in:code/web/ --exclude="*.git*"

rsync -Lvz --size-only --ipv4 -a --delete --progress -e 'ssh -p 2222' ./vendor/. --temp-dir=~/tmp/ $ENV.$SITE@appserver.$ENV.$SITE.drush.in:code/vendor/ --exclude="*.git*"

rsync -rLvz --size-only --ipv4 --progress -e 'ssh -p 2222' ./web/. --temp-dir=~/tmp/ $ENV.$SITE@appserver.$ENV.$SITE.drush.in:code/web/ --exclude="*.git*"
rsync -rLvz --size-only --ipv4 --progress -e 'ssh -p 2222' ./vendor/composer/. --temp-dir=~/tmp/ $ENV.$SITE@appserver.$ENV.$SITE.drush.in:code/vendor/composer/ --exclude="*.git*"
rsync -rLvz --size-only --ipv4 --progress -e 'ssh -p 2222' ./vendor/johnpbloch/. --temp-dir=~/tmp/ $ENV.$SITE@appserver.$ENV.$SITE.drush.in:code/vendor/johnpbloch/ --exclude="*.git*"

terminus env:commit --message "$BUILDMSG" --force -- $PANTHEONSITENAME.$ENV
#terminus env:deploy --note "GitLab:$BUILDMSG" -- $PANTHEONSITENAME.test
