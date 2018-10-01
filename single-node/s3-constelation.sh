#!/bin/bash
set -u
set -e

mkdir -p qdata/logs
CMD="constellation-node --url=https://127.0.0.1:9001/ --port=9001 --workdir=$DDIR --socket=tm.ipc --publickeys=tm.pub --privatekeys=tm.key --othernodes=https://127.0.0.1:9001/"
