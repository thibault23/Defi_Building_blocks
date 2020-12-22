pragma solidity ^0.7.3;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

//collateral backed token, similar to LP tokens
contract CollateralBacked is ERC20 {

  //pointer to the collateral smart contract
  IERC20 public collateral;
  uint public price = 1; //used as a fraction, can also be variable

  //for instance ether as collateral
  constructor (address _collateral) ERC20('Collateral Backed Token', 'CBT') {
    //instantiate our pointer to the collateral
    collateral = IERC20(_collateral);
  }

  //deposit function will mint tokens, send them over to msg.sender
  //deposit collateral
  function deposit (uint256 _deposit) external {
    //we call the approve function on the collateral token to approve the collateral back token to spend it
    collateral.transferFrom(msg.sender, address(this), _deposit);
    _mint(msg.sender, _deposit * price);
  }

  //we specifiy the amount of tokens, not the collateral amount attention
  function withdraw (uint256 _withdrawAmount) external {
    //thus the straight use of balanceOf
    require(balanceOf(msg.sender) >= _withdrawAmount, 'balance needs to be higher');
    //we burn the minted tokens so the tokens from this contract here
    _burn(msg.sender, _withdrawAmount);
    collateral.transfer(msg.sender, _withdrawAmount / price);
  }
}
