pragma solidity ^0.4.18;

contract ChainList {

  // State Variales
  address seller;
  address buyer;
  string name;
  string description;
  uint256 price;

  // events
  event LogSellArticle(address indexed _seller, string _name, uint256 _price);

  event LogBuyArticle(address indexed _seller, address indexed _buyer, string _name, uint256 _price);

  // sell an article
  function sellArticle(string _name, string _description, uint256 _price) public {
    seller = msg.sender;
    name = _name;
    description = _description;
    price = _price;

    LogSellArticle(seller, name, price);
  }

  function getArticle() public view returns (address _seller, address _buyer, string _name, string _description, uint256 _price) {

    return(seller, buyer, name, description, price);
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
  function buyArticle() payable public {
    // Check whether there is an article for sell

    require(seller != 0x0);

    // Chek article has not been sold yet
    require(buyer == 0x0);

    // we don't allow the seller to buy its own article
    require(msg.sender != seller);

    // we check that value sent correspods to proce of the article
    require(msg.value == price);

    // keep buyer's information

    buyer = msg.sender;

    // buyer can pay seller
    seller.transfer(msg.value);

    // trigger the event
    LogBuyArticle(seller, buyer, name, price);
  }
}
