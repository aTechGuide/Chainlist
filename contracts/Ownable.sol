pragma solidity ^0.4.18;

contract Ownable {
  // state variables

  address owner;

  // underscore is a place holder that represents the code of fucntion that this modofier is applied to
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  // constructor
  // This function is called only once when the contract is deployed
  function Ownable() public {
    owner = msg.sender;
  }
}