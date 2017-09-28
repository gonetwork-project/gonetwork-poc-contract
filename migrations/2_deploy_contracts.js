var ConvertLib = artifacts.require("./ConvertLib.sol");
var MetaCoin = artifacts.require("./MetaCoin.sol");
var Verify = artifacts.require("./Verify.sol");
var GoToken = artifacts.require("./GoToken.sol");
var SafeMath = artifacts.require("./math/SafeMath.sol");
var SafeERC20 = artifacts.require("./token/SafeERC20.sol");
var SmartAsset = artifacts.require("./SmartAsset.sol");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, MetaCoin);
  deployer.deploy(MetaCoin);
  deployer.deploy(Verify);
  deployer.deploy(SafeMath);
  deployer.deploy(SafeERC20);
  deployer.link(SafeMath, GoToken);
  deployer.link(SafeERC20, GoToken);
  deployer.deploy(GoToken);
};
