#!/bin/bash
# Set thist to check your custom theme/plugin if it passes WPCS uncompiled, don't forget to update with the correct path and exemptions
set -ex

ROOTPWD=`pwd`

export THEMETOCHECK=$ROOTPWD/web/wp-content/themes/twentyseventeen-child
#export THEMETOCHECK=$ROOTPWD/web/wp-content/themes/bootstrapfast-child
export PHPCS_DIR=$ROOTPWD/vendor/squizlabs/php_codesniffer/bin #phpcs v >3
export SNIFFS_DIR=$ROOTPWD/vendor/wp-coding-standards/wpcs
export THEMEIGNORE=*gulpfile.js*,*/assets/*,*.css*,*/gulp*.js,*.js*

$PHPCS_DIR/phpcs --config-set installed_paths $SNIFFS_DIR
$PHPCS_DIR/phpcs -p $THEMETOCHECK --standard=WordPress --ignore=$THEMEIGNORE
