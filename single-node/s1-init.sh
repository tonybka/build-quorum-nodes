#!/bin/bash
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

# Pull and setup Quorum
git clone https://github.com/jpmorganchase/quorum.git
cd quorum/
git checkout 0905eda48eb07a4ce0e7072c1a2ecbf690ddff77
make all
echo "PATH=\$PATH:"$PWD/build/bin >> ~/.bashrc
source ~/.bashrc
export PATH=$PWD/build/bin:$PATH

# Setup constellation
cd ..
mkdir -p constellation && cd constellation/
sudo apt-get install -y unzip libdb-dev libleveldb-dev libsodium-dev zlib1g-dev libtinfo-dev
wget https://github.com/jpmorganchase/constellation/releases/download/v0.3.2/constellation-0.3.2-ubuntu1604.tar.xz -O constellation-0.3.2-ubuntu1604.tar.xz
tar -xf constellation-0.3.2-ubuntu1604.tar.xz
cp constellation-0.3.2-ubuntu1604/constellation-node /usr/local/bin && chmod 0755 /usr/local/bin/constellation-node
rm -rf constellation-0.3.2-ubuntu1604.tar.xz constellation-0.3.2-ubuntu1604
# CVER="0.3.2"
# CREL="constellation-$CVER-ubuntu1604"
# wget -q https://github.com/jpmorganchase/constellation/releases/download/v$CVER/$CREL.tar.xz
# tar xfJ $CREL.tar.xz
# cp $CREL/constellation-node /usr/local/bin && chmod 0755 /usr/local/bin/constellation-node
# rm -rf $CREL

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