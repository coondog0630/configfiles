#!/usr/bin/env bash

# setup development directory and move configfiles over there
mkdir ~/Development
rm -f ~/Downloads/Mixbook-configfiles-*.tar*
mv ~/Downloads/Mixbook-configfiles-* ~/Development/configfiles

# setup a working copy of homebrew
sudo mkdir -p /usr/local
sudo chown -R $USER /usr/local
curl -Lsf http://github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C/usr/local
brew -v install git 

# switch over to our own branch of homebrew
git clone http://github.com/Mixbook/homebrew.git /tmp/homebrew
mv /tmp/homebrew/.git /usr/local

# cleanup
rm -rf /tmp/homebrew

# Install the packages we need
brew -v install bash
brew -v install bash-completion
brew -v install nginx
brew -v install mysql
brew -v install imagemagick
brew -v install memcached

# nginx setup
mkdir -p ~/Library/LaunchAgents
cp /usr/local/Cellar/nginx/1.0.2/org.nginx.nginx.plist ~/Library/LaunchAgents/
launchctl load -w ~/Library/LaunchAgents/org.nginx.nginx.plist

# mysql setup
unset TMPDIR
mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp
mkdir -p ~/Library/LaunchAgents
cp /usr/local/Cellar/mysql/5.5.10/com.mysql.mysqld.plist ~/Library/LaunchAgents/
launchctl load -w ~/Library/LaunchAgents/com.mysql.mysqld.plist

# memcached setup
mkdir -p ~/Library/LaunchAgents
cp /usr/local/Cellar/memcached/1.4.5/com.danga.memcached.plist ~/Library/LaunchAgents/
launchctl load -w ~/Library/LaunchAgents/com.danga.memcached.plist

# install and setup rvm and ruby version 1.9.2
bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)
rvm install 1.9.2
