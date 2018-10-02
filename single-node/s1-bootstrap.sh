#!/bin/bash
set -eu -o pipefail

# Install dependencies
add-apt-repository ppa:ethereum/ethereum
apt-get update
apt-get install -y build-essential unzip libdb-dev libleveldb-dev libsodium-dev zlib1g-dev libtinfo-dev solc sysvbanner wrk

# Install NodeJS
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Go lang
wget https://storage.googleapis.com/golang/go1.7.linux-amd64.tar.gz
tar -xf go1.7.linux-amd64.tar.gz
sudo cp -r go/ /usr/local/
rm -rf go/ go1.7.linux-amd64.tar.gz
echo "export GOROOT=/usr/local/go" >> ~/.bashrc
echo "export GOPATH=$HOME/projects/go" >> ~/.bashrc
echo "PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc
export GOROOT=/usr/local/go
export GOPATH=$HOME/projects/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# Setup constellation
CREL=constellation-0.2.0-ubuntu1604
wget -q https://github.com/jpmorganchase/constellation/releases/download/v0.2.0/$CREL.tar.xz
tar xfJ $CREL.tar.xz
cp $CREL/constellation-node /usr/local/bin && chmod 0755 /usr/local/bin/constellation-node
rm -rf $CREL

# install tessera
wget -q https://github.com/jpmorganchase/tessera/releases/download/tessera-0.6/tessera-app-0.6-app.jar
mkdir -p /home/vagrant/tessera
cp ./tessera-app-0.6-app.jar /home/vagrant/tessera/tessera.jar
echo "TESSERA_JAR=/home/vagrant/tessera/tessera.jar" >> /home/vagrant/.profile


# Pull and setup Quorum
git clone https://github.com/jpmorganchase/quorum.git
pushd quorum >/dev/null
git checkout tags/v2.0.0
make all
cp build/bin/geth /usr/local/bin
cp build/bin/bootnode /usr/local/bin
popd >/dev/null

# Install Porosity
wget -q https://github.com/jpmorganchase/quorum/releases/download/v1.2.0/porosity
mv porosity /usr/local/bin && chmod 0755 /usr/local/bin/porosity

# Create directories for node's configuration
cd ~/
mkdir qdata
qd =~/qdata
mkdir -p $qd/{logs,keys}
mkdir -p $qd/dd/geth

# done!
banner "Quorum"
echo
echo 'Quorum has been installed.'