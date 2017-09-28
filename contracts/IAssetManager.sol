pragma solidity ^0.4.15;

contract IAssetManager{

  function createAsset(uint256 cost)payable public returns(address);

  function buy(address asset) payable public returns (bool);


}