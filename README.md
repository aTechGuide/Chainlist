# Chainlist DAPP

Node JS DApp emulating craiglist on Ethereum block chain. This DAPP uses Truffle, Metamask.

## Live Preview
[ChailList Web Console](https://kamranali.in/Chainlist/)

## Truffle Commands
To compile contract  
``` truffle migrate --compile-all --reset --network ganache  // Compile contract```

To connect to console  
``` truffle console --network ganache ```

To interact with contract  
```
ChainList.deployed().then(function(instance) {app=instance;})
app.getArticlesForSale()
app.getNumberOfArticles()
app.sellArticle("Article 1 ", "Description of Article 1", web3.toWei(10, "ether"), {from: web3.eth.accounts[1]})
app.buyArticle(1, {from: web3.eth.accounts[3], value: web3.toWei(10, "ether")})
app.kill({from: web3.eth.accounts[0]})
```

To check balance  
``` web3.fromWei(web3.eth.getBalance(web3.eth.accounts[0]), "ether").toNumber() ```

Events  
``` 
var sellEvent = app.LogSellArticle({}, {fromBlock: 0, toBlock:'latest'}).watch(function(error,event) {console.log(event);}) 
sellEvent.stopWatching()
var sellEvent = app.LogSellArticle({}, {}).watch(function(error,event) {console.log(event);}) // Default for both parameters (fromBlock and toBlock) is latest
var buyEvent = app.LogBuyArticle({_seller: web3.eth.accounts[1]}, {}).watch(function(error,event) {console.log(event);})
```

## DApp Commands
Run DAPP  
``` npm run dev ```

## Web3 Commands
```
web3.fromWei(web3.eth.getBalance(web3.eth.accounts[0]), "ether").toNumber() // To get account balance
web3.eth.coinbase // To get Primary account
web3.eth.sendTransaction({from: web3.eth.accounts[0], to: web3.eth.accounts[1], value: web3.toWei(5, "ether")})
```

## Important Online Resources
- [Hex to string Converter](https://codebeautify.org/hex-string-converter)
- [Gas Station](https://ethgasstation.info/)
- [Currency Converter](https://converter.murkin.me/)
- [Online converter to ops code](https://etherscan.io/opcode-tool)
- [Contract Inheritance](http://solidity.readthedocs.io/en/latest/contracts.html#inheritance)
- [Rinkeby Ether Scan](https://rinkeby.etherscan.io/)
- [Live Ether Scan](https://etherscan.io/)
- Course [link](https://www.udemy.com/getting-started-with-ethereum-solidity-development/)
