 #!/usr/bin/env bash

set -e

log() {
  logger -s -t PROVISIONER -- "$*" 2>&1
}

_q() {
  log "> $*"
  $* > /dev/null
}

# essential dependencies

_q apt-get update -q
_q apt-get -y -q install build-essential \
  git-core  \
  htop \
  libcurl4-openssl-dev \
  libmysqlclient-dev \
  libpq-dev \
  libsqlite3-dev \
  libsqlite3-dev \
  nfs-server \
  poppler-utils \
  python-pip \
  python-software-properties \
  python2.7 \
  python2.7-dev \
  silversearcher-ag \
  tmux \
  tree \
  unzip


# ruby packages repo from brightbox

_q apt-add-repository ppa:brightbox/ruby-ng
_q apt-add-repository ppa:chris-lea/node.js

# install latest rubies

_q apt-get update -q

_q apt-get -y -q install ruby2.2 ruby2.2-dev nodejs golang

_q update-alternatives --set ruby /usr/bin/ruby2.2

_q gem install bundler pry rake --no-rdoc --no-ri

# install java

_q apt-add-repository ppa:openjdk-r/ppa
_q apt-get update -q
_q apt-get -y -q install openjdk-8-jdk openjdk-8-jre

# install leiningen

mkdir /home/vagrant/bin
wget -O /home/vagrant/bin/lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
chmod +x /home/vagrant/bin/lein
echo "export PATH=/home/vagrant/bin/:$PATH" >> /home/vagrant/.bashrc

# install git

_q add-apt-repository ppa:git-core/ppa -y

_q apt-get update -q

_q apt-get -y -q install git

# install docker

# Check that HTTPS transport is available to APT
if [ ! -e /usr/lib/apt/methods/https ]; then
  apt-get update
  apt-get install -y apt-transport-https
fi

# Add the repository to your APT sources
echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list

# Then import the repository key
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9

# Install docker
_q apt-get update
_q apt-get install -y lxc-docker


# post-install cleanup
apt-get autoremove -y

# nfs server

if [[ -e /etc/init.d/iptables-persistent ]] ; then
  /etc/init.d/iptables-persistent flush
fi

# wow nfs wow such secure

echo "/home/vagrant *(rw,sync,all_squash,anonuid=1000,insecure,no_subtree_check)" > /etc/exports
exportfs -a
/etc/init.d/nfs-kernel-server restart


# wow such network
echo "192.168.11.33 storage" > /etc/hosts
