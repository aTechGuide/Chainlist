pragma solidity ^0.4.18;

contract ChainList {

  // custom types
  struct Article {

    uint id;
    address seller;
    address buyer;
    string name;
    string description;
    uint256 price;

  }

  // because of public compiler will generate a getter for this variable
  mapping (uint => Article) public articles;
  uint articleCounter;

  // Owner
  address owner;

  // constructor
  // This function is called only once when the contract is deployed
  function ChainList() public {
    owner = msg.sender;
  }

  // deactivate the contract
  function kill() public {
    // only allow the contract owner
    require(msg.sender == owner);

    selfdestruct(owner);
  }

  // events
  event LogSellArticle(uint indexed _id, address indexed _seller, string _name, uint256 _price);

  event LogBuyArticle(uint indexed _id, address indexed _seller, address indexed _buyer, string _name, uint256 _price);

  // sell an article
  function sellArticle(string _name, string _description, uint256 _price) public {

    // increment article 
    articleCounter++;

    // Article() looks like a constructor and is automatically generated
    // store this article
    articles[articleCounter] = Article(articleCounter, msg.sender, 0x0, _name, _description, _price);

    LogSellArticle(articleCounter, msg.sender, _name, _price);
  }

  // fetch the number of articles in the ocntract
  function getNumberOfArticles() public view returns (uint) {
    return articleCounter;
  }

  // fetch and return all article IDs for articles still for sale
  function getArticlesForSale() public view returns (uint[]) {
    // prepare output array
    uint[] memory articleIds = new uint[](articleCounter);

    uint numberOfArticlesForSale = 0;

    // iterate over articles
    for (uint i = 1; i <= articleCounter; i++) {
      //keep the ID of the article is still for sale
      if (articles[i].buyer == 0x0) {
        articleIds[numberOfArticlesForSale] = articles[i].id;
        numberOfArticlesForSale++;
      }
    }
    
    // copy the articleIds array into smaller forSale array
    uint[] memory forSale = new uint[](numberOfArticlesForSale);

    for (uint j = 0; j < numberOfArticlesForSale; j++) {
      forSale[j] = articleIds[j];
    }
    return forSale;
  }

  // Buy article
  // payable implies this function may receive value. If we don't declare sunction payable we can't send value to it
  // Ways to interrput contract function execution; Throw, Assert, Require, Revert. All have same basic consequences when consition fails
  // 1 Value gets Refunded
  // 2 State changes reverted
  // 3 Function execution is interrupted so no more gas is spent
  // 4 Gas spent upto that point is not refunded to message sender
  // 5 REVERT opcode is returned equivalent of throwing exception 
  // throw = legacy
  // assert = check internal errors, invariants that should never happen, caus eof they do it implies we have bug in contract
  // require = test preconsitions
  // revert = imperatively  interrupt function execution when condition to do so is more  sophisticated than precondition
  // address has two function to send value to account: Send and Transfer. Send returns true/false depends on value transfer worked or not. So its our reponsibility to check return value and do revert etc
  // transfer automatically throws revertStyleException in contract if the value transfer fails
  function buyArticle(uint _id) payable public {

    require(articleCounter > 0);

    // we check article exists
    require(_id > 0 && _id <= articleCounter);

    // we retrieve article from mapping
    Article storage article = articles[_id];

    // Chek article has not been sold yet
    require(article.buyer == 0x0);

    // we don't allow the seller to buy its own article
    require(msg.sender != article.seller);

    // we check that value sent correspods to proce of the article
    require(msg.value == article.price);

    // keep buyer's information

    article.buyer = msg.sender;

    // buyer can pay seller
    article.seller.transfer(msg.value);

    // trigger the event
    LogBuyArticle(_id, article.seller, article.buyer, article.name, article.price);
  }
}
