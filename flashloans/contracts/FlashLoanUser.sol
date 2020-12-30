pragma solidity ^0.7.3;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import './FlashLoanProvider.sol';
import './IFlashLoanUser.sol';

contract FlashLoanUser is IFlashLoanUser {
  //function to start the flash loan and a flashLoanCallback
  function startFlashLoan(address flashloan, uint amount, address token)
  external
  {
    FlashLoanProvider(flashloan).executeFlashLoan(address(this), amount, token, bytes(''));
  }

  function flashLoanCallBack(uint amount, address token, bytes memory data)
  override
  external
  {
    //do some arbitrage, liquidation, etc...

    //reimburse borrowed _tokens
    IERC20(token).transfer(msg.sender, amount);
  }
}
