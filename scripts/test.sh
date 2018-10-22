#!/bin/bash

set -ex
ls
export THEMETOCHECK=$ROOTPWD/web/wp-content/themes/twentyseventeen-child
export PHPCS_DIR=$ROOTPWD/vendor/squizlabs/php_codesniffer/bin #phpcs v >3
export SNIFFS_DIR=$ROOTPWD/vendor/wp-coding-standards/wpcs
export THEMEIGNORE=*gulpfile.js*,*/assets/*,*.css*,*/gulp*.js
cd $PHPCS_DIR/phpcs
ls
$PHPCS_DIR/phpcs --config-set installed_paths $SNIFFS_DIR
$PHPCS_DIR/phpcs -p $THEMETOCHECK --standard=WordPress --ignore=$THEMEIGNORE
