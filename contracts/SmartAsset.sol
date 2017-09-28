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

  function SmartAsset(address _creator, uint256 _cost, address _tokenAddress,bytes32 _r, bytes32 _s){
    cost = _cost;
    creator = _creator;
    owner = _creator;
    tokenAddress = _tokenAddress;
    sellable = true;
    r= _r;
    s= _s;

  }

  //the only way this returns true is if the gameCreator signed it with their private key
  function verify(bytes hash) public constant returns (bool){
    return verifySigner(hash, r, s, creator);
  }





  // //this requires user giving SmartAsset address allowance to transfer funds
  // function buy() public returns (bool){
  //   require(sellable);
  //   GoToken token = GoToken(tokenAddress);
  //   require(token != address(0));
  //   require(token.allowance(msg.sender,address(this))> cost);
  //   require(token.transferFrom(msg.sender, address(this), cost));
  //   require(token.transfer(owner, cost));
  //   owner = msg.sender;
  //   sellable = false;
  //   return true;
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