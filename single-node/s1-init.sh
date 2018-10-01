#!/bin/bash
set -eu -o pipefail

printx () {

    COLOR="96m";

    STARTCOLOR="\e[$COLOR";
    ENDCOLOR="\e[0m";

    printf "\n$STARTCOLOR%s$ENDCOLOR\n" "-------------------------$1-------------------";
}

sudo apt install sysvbanner

banner            Quorum 
printf "\n"

# Install dependencies
sudo apt-get update
sudo apt-get install -y build-essential libssl-dev git curl

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

# Install normal Geth
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install -y ethereum
sudo mv /usr/bin/geth /usr/bin/normalGeth


# Setup constellation
CVER="0.3.2"
CREL="constellation-$CVER-ubuntu1604"
wget -q https://github.com/jpmorganchase/constellation/releases/download/v$CVER/$CREL.tar.xz
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
cd quorum/
pushd quorum >/dev/null
git checkout tags/v2.1.0
make all
cp build/bin/geth /usr/local/bin
cp build/bin/bootnode /usr/local/bin
popd >/dev/null

# Install Porosity
wget -q https://github.com/jpmorganchase/quorum/releases/download/v1.2.0/porosity
mv porosity /usr/local/bin && chmod 0755 /usr/local/bin/porosity


OLD_GOPATH=$GOPATH
GOPATH=$PWD/istanbul-tools go get github.com/getamis/istanbul-tools/cmd/istanbul
echo "PATH=\$PATH:"$PWD/istanbul-tools/bin >> ~/.bashrc
export PATH=$PWD/istanbul-tools/bin:$PATH
GOPATH=$OLD_GOPATH

# Create directories for node's configuration
cd ~/
mkdir qdata
qd =~/qdata
mkdir -p $qd/{logs,keys}
mkdir -p $qd/dd/geth