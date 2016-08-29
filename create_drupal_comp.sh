#!/bin/bash
# Script to create a new drupal instance

# @todo: change these for your local environment's
mysql_user="root"
mysql_pass="123"
drupal_admin_passowrd="Bother."

echo "Your new magnificent website name:"
read drupal_site_name

root_folder=$drupal_site_name"_repo"

#drush dl --drupal-project-rename="www"

composer create-project drupal-composer/drupal-project:8.x $root_folder --stability dev --no-interaction

#echo "create database $drupal_site_name" | mysql -u $mysql_user -p$mysql_pass



cd $root_folder

mkdir config_vcs

cd web

drush site-install --db-url=mysql://$mysql_user:$mysql_pass@localhost:3306/$drupal_site_name -y

sed -i -- 's/  # RewriteBase \//  RewriteBase \//g' .htaccess

drush cr -y

chmod 755 sites/default

cp sites/example.settings.local.php sites/default/settings.local.php

drush user-password admin --password=$drupal_admin_passowrd
echo "The pass for your wonderful website is $drupal_admin_passowrd"

echo "---------"

pwd

echo "---------"

chmod 755 sites/default/settings.php
echo "if (file_exists(__DIR__ . '/settings.local.php')) {" >> sites/default/settings.php
echo "  include __DIR__ . '/settings.local.php';" >> sites/default/settings.php
echo "}" >> sites/default/settings.php

#we remove the default configuration directory
sed -i -- 's/$config_directories.*//g' sites/default/settings.php
echo "\$config_directories['sync'] = '../config_vcs';" >> sites/default/settings.php

cd ../..

full_www_path=$root_folder"/web"

ln -s $full_www_path $drupal_site_name

echo “All finished fine ...“
