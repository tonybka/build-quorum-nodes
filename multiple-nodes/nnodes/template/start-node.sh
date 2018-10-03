#!/bin/bash

#
# Run the constellation and geth nodes
#

set -u
set -e

### TX manager configuration
TMCONF=/qdata/tm.conf

GLOBAL_ARGS="--datadir /qdata/dd --unlock 0 --password /qdata/passwords.txt --raft --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum --emitcheckpoints"

if [ ! -d /qdata/dd/geth/chaindata ]; then
  echo "[*] Mining Genesis block"
  /usr/local/bin/geth --datadir /qdata/dd init /qdata/genesis.json
fi

echo "[*] Starting Constellation node"
nohup /usr/local/bin/constellation-node $TMCONF 2>> /qdata/logs/constellation.log &

sleep 2

echo "[*] Starting node"
PRIVATE_CONFIG=$TMCONF nohup /usr/local/bin/geth $GLOBAL_ARGS 2>>/qdata/logs/geth.log

echo "[*] Waiting for node to start"
sleep 10

echo "Node started. See 'qdata/logs' for logs, and run e.g. 'geth attach qdata/dd/geth.ipc' to attach to Geth node"