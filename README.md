# Chainlist DAPP

Node JS DApp emulating craiglist on Ethereum block chain. This DAPP uses Truffle, Metamask.

## Live Preview
[ChailList Web Console](https://kamranali.in/Chainlist/)

# Developer Zone
## Truffle Commands

**Project Initialization**
``` unbox chainskills/chainskills-box ```

**To compile contract**
``` truffle migrate --compile-all --reset --network ganache ```

**To connect to console**
``` truffle console --network ganache ```

**To run test**
``` truffle test --network ganache ```

**To interact with contract**
```
ChainList.deployed().then(function(instance) {app=instance;})
app.getArticlesForSale()
app.getNumberOfArticles()
app.sellArticle("Article 1 ", "Description of Article 1", web3.toWei(10, "ether"), {from: web3.eth.accounts[1]})
app.buyArticle(1, {from: web3.eth.accounts[3], value: web3.toWei(10, "ether")})
app.kill({from: web3.eth.accounts[0]})
```

**To check balance**
``` web3.fromWei(web3.eth.getBalance(web3.eth.accounts[0]), "ether").toNumber() ```

**Events**
``` 
var sellEvent = app.LogSellArticle({}, {fromBlock: 0, toBlock:'latest'}).watch(function(error,event) {console.log(event);}) 
sellEvent.stopWatching() // To stop watching event
var sellEvent = app.LogSellArticle({}, {}).watch(function(error,event) {console.log(event);}) // Default for both parameters (fromBlock and toBlock) is latest
var buyEvent = app.LogBuyArticle({_seller: web3.eth.accounts[1]}, {}).watch(function(error,event) {console.log(event);})
var buyEvent = app.LogBuyArticle({}, {}).watch(function(error,event) {console.log(event);})
```

## DApp Commands
**Run DAPP** ``` npm run dev ```

## Web3 Commands
```
web3.fromWei(web3.eth.getBalance(web3.eth.accounts[0]), "ether").toNumber() // To get account balance
web3.eth.coinbase // To get Primary account
web3.eth.sendTransaction({from: web3.eth.accounts[0], to: web3.eth.accounts[1], value: web3.toWei(5, "ether")})
```
## Notes
- *Migrations.sol*: keeps track of which migration scripts have already been executed on each block chain instance that we are going to work with
- *Initial_migration*: deploys the migration contract that truffle interacts with to determine which contract still has to be deployed to blockchian network
- By default 0th address is unlocked in our startnode.sh file.
- If we specify from Address in chainskills network in truffle.js and put 1th address in from node.e.g. ``` from: '0x849724b2c67f00c52c2e6283e5b8a7c30a46cfab' // Second address on our private node CMD[web3.eth.accounts] ``` we need to unlock it first befor compiling our contract.
- To unlock 1st address, ``` truffle console --network chainskills // open console
  web3.personal.unlockAccount(web3.eth.accounts[1], "pass1234", 600) // unlocking account for 10 mins ```

## Important Online Resources
- [Hex to string Converter](https://codebeautify.org/hex-string-converter)
- [Gas Station](https://ethgasstation.info/)
- [Currency Converter](https://converter.murkin.me/)
- [Online converter to ops code](https://etherscan.io/opcode-tool)
- [Live Ether Scan](https://etherscan.io/)
- [Contract Inheritance](http://solidity.readthedocs.io/en/latest/contracts.html#inheritance)
- [Rinkeby Faucet](https://www.rinkeby.io/#faucet)
- [Rinkeby Ether Scan](https://rinkeby.etherscan.io/)
- [Live Ether Scan](https://etherscan.io/)
- Course [link](https://www.udemy.com/getting-started-with-ethereum-solidity-development/)

