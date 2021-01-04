pragma solidity ^0.7.3;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import './CTokenInterface.sol';
import './ComptrollerInterface.sol';
import './PriceOracleInterface.sol';

contract MyDefiProject {
  ComptrollerInterface public comptroller;
  PriceOracleInterface public oracle;

  constructor(address _addressComptroller, address _addressOracle) {
    comptroller = ComptrollerInterface(_addressComptroller);
    oracle = PriceOracleInterface(_addressOracle);
  }

  // I. LENDING PART
  //function to lend tokens on Compound, on supply seulement le collateral (pas de redeem des ctokens)
  function lend(address _cTokenAddress, uint _underlyingAmount) external {
    CTokenInterface cToken = CTokenInterface(_cTokenAddress);
    address underlyingAdress = cToken.underlying();
    IERC20(underlyingAdress).approve(cTokenAddress, underlyingAmount);
    uint result = cToken.mint(_underlyingAmount);
    require(
      result == 0,
      'cToken#mint() failed. see Compound ErrorReporter.sol for more details'
      );
   }

   //redeem the ctokens against the underlying amount + interests
   function redeem (address _cTokenAddress, uint _underlyingAmount) external {
     CTokenInterface cToken = CTokenInterface(cTokenAddress);
     uint result = cToken.redeem(cTokenAmount);
     require(
       result == 0,
       'cToken#redeem() failed. see Compound ErrorReporter.sol for more details'
     );
    }


    //IERC20(underlyingAdress).transferFrom(msg.sender, address(this), _amount);
    //CTokenInterface(_token).mint(_underlyingAmount);
    //CTokenInterface(_token).redeem(_underlyingAmount);

    // II. BORROWING PART
    //function to enter market
    function enterMarket(address cTokenAddress) external {
      address[] memory markets = new address[](1);
      markets[0] = cTokenAddress;
      uint[] memory results = comptroller.enterMarkets(markets);
      require(
        results[0] == 0,
        'comptroller#enterMarket() failed. see Compound ErrorReporter.sol for more details''
        )
    }
    
    //once we have enter a market, we are ready to borrow
    //function to borrow

    //function to repay borrow

    //function to get max borrow

}
