pragma solidity ^0.4.15;

contract Verify {

  function Verify() {
  }

  function verifyMessage(bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s) constant returns (address) {
    bytes memory prefix = "\x19Ethereum Signed Message:\n32";
    bytes32 prefixedHash = sha3(prefix, _message);
    address signer = ecrecover(prefixedHash, _v, _r, _s);
    return signer;
  }
  //constant is an alias to view, promising the function is read-only
  function verifySigner(bytes32 _message, bytes32 _r, bytes32 _s, address signer)  constant returns (bool) {
    uint8  v = 28;
    if(verifyMessage(_message, v, _r, _s) == signer){
      return true;
    }
    if(verifyMessage(_message, v-1, _r, _s) == signer){
          return true;
    }
    return false;

  }

}