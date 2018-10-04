//
// Create contract private with the nodes on behalf of specific keys
//

var toKeys=["_NODEKEY_"];

// use the first account to process transaction
a = eth.accounts[0]
web3.eth.defaultAccount = a;

// Simple Solidity smart contract source code
var simpleSource = 'contract SimpleStorage { uint public storedData; constructor (uint initVal) public { storedData = initVal; } function set(uint x) { storedData = x; } function get() constant returns (uint retVal) { return storedData; } }'
//Compile the source code
var simpleCompiled = web3.eth.compile.solidity(simpleSource);
var simpleRoot = Object.keys(simpleCompiled)[0];
var simpleContract = web3.eth.contract(simpleCompiled[simpleRoot].info.abiDefinition);
var simple = simpleContract.new(42, {from:web3.eth.accounts[0], data: simpleCompiled[simpleRoot].code, gas: 300000, privateFor: toKeys}, function(e, contract) {
	if (e) {
		console.log("err creating contract", e);
	} else {
		if (!contract.address) {
			console.log("Contract transaction send: TransactionHash: " + contract.transactionHash + " waiting to be mined...");
		} else {
			console.log("Contract mined! Address: " + contract.address);
			console.log(contract);
		}
	}
});