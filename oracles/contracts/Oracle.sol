pragma solidity ^0.7.3;

contract Oracle {
  struct Data {
    uint date;
    uint payload;
  }

  address public admin;
  mapping(address => bool) public reporters;
  mapping(bytes32 => Data) public data;

  constructor (address _admin) {
    admin = _admin;
  }

  function updateReporter(address _reporter, bool _isReporter) external {
    require(msg.sender == admin, 'not admin');
    reporters[_reporter] = _isReporter;
  }

  function updateData(bytes32 _key, uint256 _payload) external {
    require(reporters[msg.sender] == true, 'not a reporter');
    data[_key] = Data(block.timestamp, _payload);
  }

  function getData(bytes32 _key) external
  view
  returns(bool result, uint256 date, uint256 payload)
  {
    if(data[_key].date == 0) {
      return(false, 0, 0);
    }
    return(true, data[_key].date, data[_key].payload);
  }
}
