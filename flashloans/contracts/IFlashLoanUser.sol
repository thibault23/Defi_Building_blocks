pragma solidity ^0.7.3;

interface IFlashLoanUser {

  //the bytes variable is some data forwarded from the flash loan provider
  function flashLoanCallBack(uint amount, address token, bytes memory data) external;
}
