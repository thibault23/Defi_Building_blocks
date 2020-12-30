//token lender in the flashloan

pragma solidity ^0.7.3;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/utils/ReentrancyGuard.sol';
import './IFlashLoanUser.sol';

contract FlashLoanProvider is ReentrancyGuard {
  mapping(address => IERC20) public tokens;

  //pass to the constructor an array of addresses of tokens we support
  constructor (address[] memory _tokens) {
    for(uint i = 0; i < _tokens.length; i++)
    {
      tokens[_tokens[i]] = IERC20(_tokens[i]);
    }
  }

  //a noter que A can execute a flashloan for B which is why we have a callback address
  function executeFlashLoan(address callback, uint amount, address _token, bytes memory data)
  nonReentrant()
  external
  {
    IERC20 token = tokens[_token];
    uint originalBalance = token.balanceOf(address(this));
    require(address(token) != address(0), 'token not supported');
    require(originalBalance >= amount, 'amount too high');
    token.transfer(callback, amount);
    // instantiate a pointer to the borrower
    IFlashLoanUser(callback).flashLoanCallBack(amount, _token, data);
    //at this point, the flash user should have returned the money
    require(token.balanceOf(address(this)) == originalBalance, 'flashloan not reimbursed');
  }
}
