var Verify = artifacts.require("./Verify.sol");

contract('Verify', function(accounts) {

  // it("should pass verification", function() {
  //   // Get a reference to the deployed MetaCoin contract, as a JS object.
  //   Verify.deployed().then(function(instance){
  //       let msg = web3.sha3("hello")


  //       let sig = web3.eth.sign(web3.eth.accounts[0], msg)
  //       let r = sig.substr(0,66)
  //       let s = "0x" + sig.substr(66,64)
  //       //https://ethereum.stackexchange.com/questions/2171/how-does-one-properly-use-ecrecover-to-verify-ethereum-signatures
  //       let v = 28

  //       return instance.verifyMessage.call(msg,v,r,s)


  //   }).then(addr=>{
  //           assert.equal(addr, web3.eth.accounts[0], "Signatures match");
  //   }).catch(e => {
  //       console.error(e)
  //   });;

  // });

  // it("should fail verification", function() {
  //   // Get a reference to the deployed MetaCoin contract, as a JS object.
  //   Verify.deployed().then(function(instance){
  //       let msg = web3.sha3("hello")
  //       let addr = web3.eth.accounts[1]

  //       let sig = web3.eth.sign(addr, msg)
  //       let r = sig.substr(0,66)
  //       let s = "0x" + sig.substr(66,64)
  //       let v = 28

  //       return instance.verifyMessage.call(msg,v,r,s)


  //   }).then(addr=>{
  //           assert.notEqual(addr, web3.eth.accounts[0], "Signatures Doesnt Match as Expected");
  //           assert.equal(addr, web3.eth.accounts[1], "Signatures matches As Expected");
  //   }).catch(e => {
  //       console.error(e)
  //   });;

  // });

  it("should pass signer verification", function() {
    // Get a reference to the deployed MetaCoin contract, as a JS object.
    Verify.deployed().then(function(instance){

        let addr = web3.eth.accounts[0]
        let msg = web3.sha3(instance.address);
        let sig = web3.eth.sign(addr, msg)
        let r = sig.substr(0,66)
        let s = "0x" + sig.substr(66,64)

        let v = 27

        return instance.verifySigner.call(msg,r,s, web3.eth.accounts[0]);


    }).then(verified=>{
            assert.equal(verified,true, "Signature Matches as Expected");

    }).catch(e => {
        console.error(e)
    });;

  });

  it("should fail signer verification", function() {
    // Get a reference to the deployed MetaCoin contract, as a JS object.
    Verify.deployed().then(function(instance){

        let addr = web3.eth.accounts[0]
        let msg = web3.sha3(instance.address);
        let sig = web3.eth.sign(addr, msg)
        let r = sig.substr(0,66)
        let s = "0x" + sig.substr(66,64)
        let v = 27

        return instance.verifySigner.call(msg,r,s, web3.eth.accounts[1]);


    }).then(verified=>{
            assert.equal(verified,false, "Signature Fails as Expected");

    }).catch(e => {
        console.error(e)
    });;

  });

});


