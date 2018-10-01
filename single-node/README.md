# Exposition of *Quorum Node*

**This is what we set up for each node.**

 * Enode and *nodekey* file to uniquely identify each node on the network.
   * *static-nodes.json* file that lists the Enodes of nodes that can participate in the Raft consensus.
 * Ether account and *keystore* directory for each node.
   * The account gets written into the *genesis.json* file that each node runs once to bootstrap the blockchain.
 * The *tm.conf* file that tells Quorum where all the node's keys are and where all the other nodes are.
 * Public/private Keypairs for Quorum private transactions.
 * A script for starting the Geth and Constellation processes in each container, *start-node.sh*.
 * A folder, *logs/*, for Geth and Constellation to write their log files to.

 **In addition we create some utility scripts on the host.**

  * A *docker-compose.yml* file that can be used with docker-compose to create the network of containers.
  * Two sample contract creation scripts:
    * *contract_pub.js* - creates a public contract, visible to all.
    * *contract_pri.js* - creates a private contract between the sender and Node 2.