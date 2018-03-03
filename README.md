# Chainlist DAPP

This DAPP is an emulatin of craiglist and is build as a project of [this](https://www.udemy.com/getting-started-with-ethereum-solidity-development/) course.  
We have used Ethereum block chain and Truffle to build this DAPP

## Commands
### Events
To watch Event  
``` var sellEvent = app.LogSellArticle({}, {fromBlock: 0, toBlock:'latest'}).watch(function(error,event) {console.log(event);}) ```

To stop watching event   
``` sellEvent.stopWatching() ```

To watch Latest Event  
``` var sellEvent = app.LogSellArticle({}, {}).watch(function(error,event) {console.log(event);}) // Default for both parameters (fromBlock and toBlock) is latest ```

## Important Online Resources
- [Hex to string Converter](https://codebeautify.org/hex-string-converter)
