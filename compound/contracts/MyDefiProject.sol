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
    IERC20(underlyingAdress).approve(_cTokenAddress, _underlyingAmount);
    uint result = cToken.mint(_underlyingAmount);
    require(
      result == 0,
      'cToken#mint() failed. see Compound ErrorReporter.sol for more details'
      );
   }

   //redeem the ctokens against the underlying amount + interests
   function redeem (address _cTokenAddress, uint _underlyingAmount) external {
     CTokenInterface cToken = CTokenInterface(_cTokenAddress);
     uint result = cToken.redeem(_underlyingAmount);
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
    function borrow(uint _borrowAmount, address _cTokenAddress) external {
      CTokenInterface cToken = CTokenInterface(_cTokenAddress);
      address underlyingAddress = cToken.underlying();
      uint result = cToken.borrow(_borrowAmount);
      require(
        result == 0,
        'cToken#borrow() failed. see Compound ErrorReporter.sol for more details'
      );
    }

    //function to repay borrow
    function repayBorrow(uint _repayAmount, address _cTokenAddress) external {
      CTokenInterface cToken = CTokenInterface(_cTokenAddress);
      address underlyingAddress = cToken.underlying();
      IERC20(underlyingAdress).approve(_cTokenAddress, _repayAmount);
      uint result = cToken.repayBorrow(_repayAmount);
      require(
        result == 0,
        'cToken#repayBorrow() failed. see Compound ErrorReporter.sol for more details'
      );
    }

    //function to get max borrow
    function getMaxBorrow(address _cTokenAddress) external view returns(uint) {

      (uint result, uint liquidity, uint shortfall) = comptroller
        .getAccountLiquidity(address(this)));
      require(
        result == 0,
        'cToken#getAccountLiquidity() failed. see Compound ErrorReporter.sol for more details'
      );
      require(shortfall == 0, 'account underwater');
      require(liquidity > 0, 'account does not have collateral');

      uint underlyingPrice = oracle.getUnderlyingPrice(_cTokenAddress);

      return liquidity / underlyingPrice;
    }
}
