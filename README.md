
---
# WordPress Composer & Gitlab on Pantheon

Fork of [Advanced WordPress on Pantheon by Andrew Taylor](https://github.com/ataylorme/Advanced-WordPress-on-Pantheon) so it can work on GitLab, minimizing separate accounts

## Purpose

* Local development environment with [Lando](https://docs.devwithlando.io/)
* Asset compilation with [gulp](https://gulpjs.com/) 4
* PHP dependency management with [Composer](https://getcomposer.org/)
* Source control, build and testing processes run all in [GitLab](https://gitlab.com/)
* Enforced [WordPress coding standards](https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards) with [PHP code sniffer](https://github.com/squizlabs/PHP_CodeSniffer)

## GitLab Setup
You will need to add the following environment variables your project's GitLab UI. See [GitLab Environment Variables](https://gitlab.com/help/ci/variables/README#variables)/ for details.

* `PANTHEONSITENAME`:  Name of the Pantheon site to run tests on, e.g. my_site
* `MACHINETOKEN`: The Pantheon machine token https://pantheon.io/docs/machine-tokens/
* `EMAIL`:      The email address to use when making commits
* `SITE`: The SITE UUID https://pantheon.io/docs/sites/#site-uuid
* `STAGING_PRIVATE_KEY`: Ssh private key so your runners can ssh to Pantheon for the compiled assets. Create you public key here and add to Pantheon https://pantheon.io/docs/ssh-keys/. You need private key added in this variable.

## Getting Started
1) Create WP Pantheon site. Setup all the variables from the GitLab setup.
2) Clone this repo into Gitlab and clone locally.
3) Setup the GitLab environment variables in your project.
4) Run composer update to run locally.(Local development still in works)
5) Git commit and push your changes, when all is setuped correctly, your CI runners will push the wp core, plugins and themes defined in the composer files. For the custom theme/plugin, it will also compile your assets and Git Commit them to Pantheon in DEV and TEST environments.

## Local Development
TODO: Create a local development environment workflow that with fit in this deployment process

### Using Lando as a local development environment
First, take care of the one-time setup steps below:
* Install [Lando](https://docs.devwithlando.io/) if not already installed
* Edit `.lando.yml` and update `name`, `site` and `id` to match those of your Pantheon site
    - You will also need to edit the node proxy if you wish to access BrowserSync at a different URL

Then, use `lando start` and `lando stop` to start and stop the local development environment.

After cloning this repository you will need to download dependencies. This can be done through Lando with the commands below:
* `lando composer-install`
* `lando gulp-build`

Tests can also be run locally on Lando with the commands below:
* `lando composer local-behat`
* `lando composer unit-test`

### Prerequisites

* Install [Composer](https://getcomposer.org) if not already installed
* Install [NodeJS](https://nodejs.org/en/) and [NPM](https://www.npmjs.com/) if not already installed


### Updates and file changes
** Note: ** if you are using Lando for local development prefix all of the commands below with `lando ` to run them on Lando instead of your local system. For example, `npm run dev` would become `lando npm run dev`.

* `composer update` will need to be ran after any changes to `composer.json`
    - Any non-custom PHP code, including to WordPress core, new plugins, etc., should be managed with Composer and updated in this way and avoid touching anything in the DEV environment.
* `npm run gulp` will need to be ran in `web/wp-content/themes/twentyseventeen-child` after any changes to `web/wp-content/themes/twentyseventeen-child/source` files
    - `npm run watch` can be used to build the production CSS and JavaScript files, watch for changes in the source files, and rebuild the production files after a change.
    - `npm run dev` is the same as above but it also starts a [BrowserSync](https://browsersync.io/) instance for automated reloading. Be sure to update the `url` export in `web/wp-content/themes/twentyseventeen-child/gulp/constants.js` with your local development URL. Unless you are using Lando, in which case leave it set to `https://nginx/`.
* `npm install` will need to be ran after any changes to `web/wp-content/themes/twentyseventeen-child/package.json`
    - This is for advanced users who wish to customize their frontend build process.
