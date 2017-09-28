pragma solidity ^0.4.15;

import "./lifecycle/TokenDestructible.sol";
import "./Verify.sol";
import "./GoToken.sol";

//TODO: this could be a struct, we need to test the gas pricing
//This asset is also ownable
contract SmartAsset is TokenDestructible,Verify{

  //mapping(address=>uint256) withdrawals;

  address public  creator;
  bytes32 r;
  bytes32 s;
  uint256 public cost;
  bool public sellable;
  address tokenAddress;

  function SmartAsset(address _creator, uint256 _cost, address _tokenAddress){
    cost = _cost;
    creator = _creator;
    owner = _creator;
    tokenAddress = _tokenAddress;
    sellable = true;
  }

  function setVerificationParams(bytes32 _r, bytes32 _s)onlyOwner payable public returns(bool){
    r = _r;
    s = _s;
    return true;
  }

  function verify(bytes32 hash) public constant returns (bool){
    require(r.length > 0);
    require(s.length >0);
    return verifySigner(hash, r, s, creator);
  }

  //related to https://github.com/ethereum/web3.js/issues/445
  // function verify_() internal constant returns (bool){
  //   bytes32 hash = sha3(this);
  //   return verifySigner(hash,r,s,creator);
  // }


  function isSellable(bool _flag) onlyOwner{
    sellable = _flag;
  }

  modifier only(address _a) {
    require(msg.sender == _a);
    _;
  }

  function changeOwnership(address _newOwner) only(tokenAddress) payable returns (bool){
    require(_newOwner != address(0));
    owner = _newOwner;
    return true;
  }

  function changeTokenAddress(address _newTokenAddress) onlyOwner payable returns (bool){
    require(_newTokenAddress != address(0));
    tokenAddress = _newTokenAddress;
    return true;
  }

  function changeCost(uint256 _cost) onlyOwner payable returns (bool){
    require(_cost >=0);
    cost = _cost;
    return true;
  }
  /**
   * @notice Terminate contract and refund to owner
   * @notice The called token contracts could try to re-enter this contract. token parameter must be trusted.
   */
  function destroy() onlyOwner public {
    //recall, token address must be trusted or this could cause havoc as token.transfer called
    address[] memory tokens = new address[](1);
    tokens[0] = tokenAddress;
    super.destroy(tokens);
  }


}