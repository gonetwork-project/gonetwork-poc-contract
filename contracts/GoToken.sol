pragma solidity ^0.4.15;


import './token/StandardToken.sol';

contract GoToken is StandardToken{
  string public constant name = "GoToken";
  string public constant symbol = "GOTK";
  uint8 public constant decimals = 18;

  uint256 public constant INITIAL_SUPPLY = 10000 * (10 ** uint256(decimals));

  /**
   * @dev Constructor that gives msg.sender all of existing tokens.
   */
  function GoToken() {
    totalSupply = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
  }


}