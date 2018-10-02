#!/bin/bash
set -u
set -e

mkdir -p ~/qdata/logs
TMCONF=~/qdata/tm.conf

GETH_ARGS="--datadir ~/qdata/dd --raft --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum --nodiscover --unlock 0 --password ~/qdata/passwords.txt --emitcheckpoints"

if [ ! -d ~/qdata/dd/geth/chaindata ]; then
  echo "[*] Mining Genesis block"
  /usr/local/bin/geth --datadir ~/qdata/dd init ~/qdata/genesis.json
fi

echo "[*] Starting Constellation node"
nohup /usr/local/bin/constellation-node $TMCONF 2>> ~/qdata/logs/constellation.log &

sleep 2

echo "[*] Starting node"
PRIVATE_CONFIG=$TMCONF nohup /usr/local/bin/geth $GETH_ARGS --raftport 50401 --rpcport 22000 --port 21000 2>>~/qdata/logs/geth.log