pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/GoToken.sol";

contract TestGoToken {

  function testInitialBalanceUsingDeployedContract() {
    GoToken go = GoToken(DeployedAddresses.GoToken());

    uint expected = 10000000000000000000000;

    Assert.equal(go.balanceOf(msg.sender), expected, "Owner should have 10000 GoToken initially");
  }

  function testInitialBalanceWithNewGoToken() {
    GoToken go = new GoToken();

    uint expected = 10000000000000000000000;

    Assert.equal(go.balanceOf(address(this)), expected, "Owner should have 10000 GoToken initially");
  }

}