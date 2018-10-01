#!/bin/bash

ips=("[ip-address-node-1]" "[ip-address-node-2]" "[ip-address-node-3]")
qd =~/qdata

# Make static-nodes.json and store keys
echo '[1] Creating Enodes and static-nodes.json.'
echo "[" > $qd/static-nodes.json
echo "]" >> $qd/static-nodes.json

# Create accounts, keys and genesis.json file
echo '[2] Creating Ether accounts and genesis.json.'
cat >> $qd/passwords.txt <<EOF
    [yourpassword]
EOF

cat >> $qd/genesis.json <<EOF
{
  "alloc": {
EOF
accountret=`/usr/bin/geth --datadir=./data --password ./password.txt account new | cut -c 11-50`
cat >> genesis.json <<EOF
    "${accountret}": {
          "balance": "1000000000000000000000000000"
    }
EOF
cat >> genesis.json <<EOF
  },
  "coinbase": "0x0000000000000000000000000000000000000000",
  "config": {
    "homesteadBlock": 0
  },
  "difficulty": "0x0",
  "extraData": "0x",
  "gasLimit": "0x2FEFD800",
  "mixhash": "0x00000000000000000000000000000000000000647572616c65787365646c6578",
  "nonce": "0x0",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "timestamp": "0x00"
  }
EOF

# Make node list for tm.conf
nodelist=
n=1
for ip in ${ips[*]}
do
    sep=`[[ $ip != ${ips[0]} ]] && echo ","`
    nodelist=${nodelist}${sep}'"http://'${ip}':9000/"'
    let n++
done


# Create Quorum keys
n=1
qd = ~/qdata
mkdir -p $qd/keys

for ip in ${ips[*]}
do
    cat config/tm.conf \
        | sed s/_NODEIP_/${ips[$((n-1))]}/g \
        | sed s%_NODELIST_%$nodelist%g \
            > $qd/tm.conf
mv $qd/static-nodes.json $qd/dd/static-nodes.json
constellation-node --workdir=$qd/keys --generatekeys=tm < /dev/null > /dev/null
constellation-node --workdir=$qd/keys --generatekeys=tma < /dev/null > /dev/null


