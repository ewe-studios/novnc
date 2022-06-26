#!/bin/bash

# add user "novnc" to primary group "users" (will remove any other group membership)
addgroup -g 1001 sudo
addgroup -g 1002 users

addgroup -g "$GUID" novnc

# setup env for user novnc
mkdir -p '/home/novnc'
adduser -D -G novnc -u "$PUID" -s /bin/bash --home /home/novnc novnc

# add user "novnc" to secondary group "novnc" (will retain primary membership)
adduser novnc novnc
adduser novnc users
adduser novnc sudo
adduser novnc video
adduser novnc input

chown novnc:novnc /home/novnc

# change permission of folders
chown -R root:users /tmp/
chown -R root:users /var/
chown -R root:users /etc/

echo "$TZ" > /etc/timezone

chmod 0775 /etc/timezone
chmod 0775 /etc/localtime

# set shell for user novnc
export HOME=/home/novnc

mkdir -p $HOME/lib/perl5
export PERL5LIB=${HOME}/lib/perl5
export PERL_MM_OPT="INSTALL_BASE=${PERL5LIB}"

curl -L https://cpanmin.us | perl - --sudo App::cpanminus
cpanm Term::ExtendedColor File::LsColor
cpan Term::ExtendedColor File::LsColor
git clone https://github.com/forkkit/ls--.git
cd ls--
perl Makefile.PL
make
make install
cd -
rm -rf ls--
