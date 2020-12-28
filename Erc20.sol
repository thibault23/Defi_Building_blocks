pragma solidity ^0.7.3;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

interface ContractB {
  function deposit(uint amount) external;
  function withdraw (uint amount) external
}

//simple token
contract Token is ERC20 {
  constructor () ERC20('token', 'TKN') {
  }
}

//simple token with preminting
contract Token is ERC20 {
  constructor (uint256 _amount) ERC20('token', 'TKN') {
    _mint(msg.sender, _amount);
  }
}

//simple token with minting functionnality
contract Token is ERC20 {

  address private owner;

  constructor () ERC20('token', 'TKN') {
    owner = msg.sender;
  }

  function mint (uint256 _amount) external {
    require(owner == msg.sender, "not allowed");
    _mint(msg.sender, _amount);
  }
}


//Faucet
contract Token is ERC20 {

  //address private owner;

  constructor () ERC20('token', 'TKN') {
    //owner = msg.sender;
  }

  function faucet (uint256 _amount, address _to) external {
    //require(owner == msg.sender, "not allowed");
    _mint(_to, _amount);
  }
}

//token transfers
contract ContractA {

  IERC20 public token;

  constructor (address _token) {
    token = IERC20(_token);
  }

  function deposit(uint256 _amount) external {
    //we need to call approve so we use the "transferFrom" function
    token.transferFrom(msg.sender, address(this), _amount);
  }

  function withdraw(uint256 _amount) external {
    token.transfer(msg.sender, _amount);
  }
}

//token transfers and forward to B


contract ContractA {

  IERC20 public token;
  ContractB public contractb;

  constructor (address _token, address _contractb) {
    token = IERC20(_token);
    contractb = ContractB(_contractb);
  }

  function deposit(uint256 _amount) external {
    //we need to call approve so we use the "transferFrom" function
    token.transferFrom(msg.sender, address(this), _amount);
    //need to approve contractb for spending token amount
    token.approve(address(contractb), amount);
    contractb.deposit(_amount); //in the implementation itself of contractB, it will call the deposit function where parameter msg.sender will be contractA
  }

  function withdraw(uint256 _amount) external {
    contractb.withdraw(_amount);
    token.transfer(msg.sender, _amount);
  }
}
