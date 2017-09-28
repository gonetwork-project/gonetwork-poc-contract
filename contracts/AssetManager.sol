pragma solidity ^0.4.15;

import "./SmartAsset.sol";
import "./GoToken.sol";
import "./math/SafeMath.sol";
import "./ReentrancyGuard.sol";

contract AssetManager is Ownable,ReentrancyGuard{

  //game public address =>  address of SmartAssets

  //at the moment, no modders are supported, in that case, the game creator
  //must create a trust network between modders and their game network
  mapping(address=>address[]) public assets;


  address private tokenAddress;

  function AssetManager(address _tokenAddress){
    tokenAddress = _tokenAddress;
    owner = msg.sender;
  }

  //the sender of this function claims the asset
  function createAsset(uint256 _cost) public returns (address){

    GoToken token = GoToken(tokenAddress);
    //@params:creator, signature,cost,token
    SmartAsset asset = new SmartAsset(msg.sender, _cost, tokenAddress );
    assets[msg.sender].push(address(asset));
    //this is an illegal call, this contract doesnt have allowance to make said call
    token.transferFrom(msg.sender, address(asset), _cost * 1500);
    return address(asset);
  }

  //this requires user giving AssetManager Address allowance to purchase on their behalf
  function buy(address _asset) nonReentrant external
  {
    SmartAsset asset = SmartAsset(_asset);
    GoToken token = GoToken(tokenAddress);

    require(asset != address(0x0));
    require(token != address(0x0));
    //ensure we have allowance to make the purchase
    require(token.allowance(msg.sender,address(this)) > asset.cost());
    require(asset.sellable());

    //again same issue as above
    token.transferFrom(msg.sender, asset.owner(), asset.cost());
    asset.transferOwnership(msg.sender);
  }

  function destroy(address _asset) public {
    SmartAsset asset = SmartAsset(_asset);
    asset.destroy();

  }




}