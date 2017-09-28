pragma solidity ^0.4.15;

import './token/StandardToken.sol';
import './IAssetManager.sol';
import './math/SafeMath.sol';
import './SmartAsset.sol';
import './token/SafeERC20.sol';

contract GoToken is StandardToken,IAssetManager {
  using SafeERC20 for ERC20;
  string public constant name = "GoToken";
  string public constant symbol = "GOTK";
  uint8 public constant decimals = 18;

  uint256 public constant INITIAL_SUPPLY = 10000 * (10 ** uint256(decimals));
  address private minter;
  uint256 public constant TRANSACTION_FEE_PPT = 15; //1.5%
  uint256 public constant CREATOR_SECONDARY_PPT = 300;  //30%
  uint256 public constant RESELLER_PPT = 650;//65%
  uint256 public constant CREATOR_PRIMARY_PPT= 950; //95%
  uint256 public constant ASSET_STAKE_PPT = 50;//5%
  /**
   * @dev Constructor that gives msg.sender all of existing tokens.
   */
  function GoToken() {
    totalSupply = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
    minter = msg.sender;
  }

  /*IAssetManager Implementation */
  //gameCreatorAddress=>SmartAsset[] address
  mapping(address=>address[]) public assets;

  function createAsset(uint256 cost,bytes32 _r, bytes32 _s) payable public returns(address){
    //address _creator, uint256 _cost, address _tokenAddress
    SmartAsset asset = new SmartAsset(msg.sender, cost,address(this), _r,_s);
    require(asset!= address(0));
    assets[msg.sender].push(address(asset));
    return address(asset);
  }

  //recall inter-function calls msg.sender is still the same address as the initial caller
  //hence the contract is executed under the same context unlike actor model
  function buy(address _asset)  payable public returns (bool){
    SmartAsset asset = SmartAsset(_asset);
    require(asset != address(0));
    uint256 cost = asset.cost();
    require(balanceOf(msg.sender) > cost);
    uint256 fee = calc_ppt(cost,TRANSACTION_FEE_PPT);
    cost = SafeMath.sub(cost,fee);
    uint256 stake =calc_ppt(cost, ASSET_STAKE_PPT );
    cost = SafeMath.sub(cost,stake);
    if(asset.creator() == asset.owner()){
      //transfer(asset.creator(), cost * 95 /100);
      SafeERC20.safeTransfer(this,asset.creator(), cost);
      SafeERC20.safeTransfer(this,minter, fee);
      SafeERC20.safeTransfer(this,address(asset), stake);
      asset.changeOwnership(msg.sender);
      //transfer(address(asset))
    }else{
      transfer(asset.creator(), calc_ppt(cost,CREATOR_SECONDARY_PPT));
      transfer(minter, fee);
      asset.changeOwnership(msg.sender);
    }
    // else{
    //   transfer(asset.creator(), cost * 5 / 10);
    //   transfer()
    // }
    return true;
  }

  function simpleBuy(address _asset) payable public returns (bool){
    SmartAsset asset = SmartAsset(_asset);
    require(asset != address(0));
    uint256 cost = asset.cost();
    require(balanceOf(msg.sender) > cost);
    SafeERC20.safeTransfer(this, asset.owner(), cost);
    asset.changeOwnership(msg.sender);
    return true;
  }

  //use constant, we arent changing state here
  function calc_ppt(uint256 val, uint256 ppt) public constant returns(uint256) {
    return SafeMath.div(SafeMath.mul(val, ppt), 1000);
  }

}