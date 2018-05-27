#!/bin/bash
#This script assumes very little other than a fresh Ubuntu install (using the Windows store) on Win10 1709 or newer with WSL installed already
#See the DOCKER_CHANNEL and DOCKER_COMPOSE_VERSION variables below to update from 18.03-stable/1.21.0
mkdir ~/src && cd ~/src && set -x && set -v

cp ~/.bashrc ~/.bashrc.backup
cp ~/.profile ~/.profile.backup

sudo apt -y update && sudo apt -y upgrade

#pre-cleanup
sudo apt-get purge -y docker.io  docker docker-ce && sudo apt-get autoremove -y --purge docker.io && sudo apt-get autoclean && sudo rm -rf /var/lib/docker && sudo rm /etc/apparmor.d/docker && sudo groupdel docker

sudo apt-get -y install build-essential checkinstall cvs subversion git-core mercurial && sudo chown $USER /usr/local/src && sudo chmod u+rwx /usr/local/src

# Add Docker's official GPG key.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common && sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && sudo apt-get -y update

sudo mkdir /c;
sudo mount --bind /mnt/c /c
echo "sudo mount --bind /mnt/c /c" >> ~/.bashrc;
#add via visudo nick ALL=(root) NOPASSWD: /bin/mount
sudo visudo

# Install packages to allow apt to use a repository over HTTPS then Verify the fingerprint.
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common && apt-key fingerprint 0EBFCD88

## Install Docker in WSL Pick the release channel and install docker-ce


# Allow your user to access the Docker CLI without needing root.
sudo usermod -aG docker $USER

# Install Docker Compose.
export DOCKER_COMPOSE_VERSION=1.21.0 && sudo curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose

## Prepare Sync [optional] - Taken from: https://github.com/EugenMayer/docker-sync/wiki/docker-sync-on-Windows#2-install-a-distro
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH

#I'm using a modified version of docker-sync to deal with a bash/wsl issue where readlink returns nothing, but realpath behaves as expected
sudo apt-get -y install ruby ruby-dev gem && sudo gem install specific_install && sudo gem specific_install -l https://github.com/rainabba/docker-sync.git

#cd ~/src/ && wget http://caml.inria.fr/pub/distrib/ocaml-4.06/ocaml-4.06.0.tar.gz && tar xvf ocaml-4.06.0.tar.gz; cd ocaml-4.06.0 && ./configure && make world && make opt && umask 022 && sudo make install && sudo make clean && cd ~/src/ && echo 'Done with ocaml' && cd ~/src/ && wget https://github.com/bcpierce00/unison/archive/v2.51.2.tar.gz && tar xvf v2.51.2.tar.gz && cd unison-2.51.2 && make UISTYLE=text && sudo cp src/unison /usr/local/bin/unison && sudo cp src/unison-fsmonitor /usr/local/bin/unison-fsmonitor && cd ~/src/ && echo 'Done with unison'

#fix /mnt/c so it's not so public
sudo chmod 755 /mnt/c

#install Node.js and NPM
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -; sudo apt-get -y install -y nodejs;

echo 'export PATH=/home/linuxbrew/.linuxbrew/Homebrew/Library/Homebrew/vendor/portable-ruby/2.3.3/bin:$PATH' >>~/.profile
echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:'$(brew --prefix)/bin:$(brew --prefix)/sbin':$PATH"' >>~/.profile
echo 'export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"' >>~/.profile
echo 'export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"' >>~/.profile
echo "export DOCKER_HOST=tcp://0.0.0.0:2375" >> ~/.bashrc
source ~/.profile && source ~/.bashrc