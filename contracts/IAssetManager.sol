pragma solidity ^0.4.15;

contract IAssetManager{

  function createAsset(uint256 cost,bytes32 _r, bytes32 _s)payable public returns(address);

  function buy(address asset) payable public returns (bool);


}