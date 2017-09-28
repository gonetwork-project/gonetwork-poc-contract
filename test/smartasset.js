var SmartAsset = artifacts.require("./SmartAsset.sol");


contract('SmartAsset', function(accounts) {
  it("should get parameter values", function() {
    var addr = web3.eth.accounts[0];
    var sa = null;
    var msg = web3.sha3(addr);
    var sig = web3.eth.sign(addr, msg)
    var r = sig.substr(0,66)
    var s = "0x" + sig.substr(66,64)
    SmartAsset.new(addr, 500000,addr).then(function(i){
      sa = i;

      var msg = web3.sha3(sa.address);
      var sig = web3.eth.sign(addr, msg)
      var r = sig.substr(0,66)
      var s = "0x" + sig.substr(66,64)
      return sa.setVerificationParams(r,s, {from:addr});


    }).then(function(setVerificationParams){
      assert(setVerificationParams);
      return sa.cost.call()
    }).then(function(cost){

      assert.equal(cost.toNumber(),500000,"YES");
      var msg = web3.sha3(sa.address);
      return sa.verify(msg);
    }).then(function(valid){
      assert.equal(valid, true, "Verified object");
      return sa.verify(web3.sha3(web3.eth.accounts[1]));
    })
    .then(function(invalid){
       assert.equal(invalid, false, "correctly found incorrect hash");
       return sa.changeOwnership(web3.eth.accounts[2], {from: addr});
     })
     .then(function(changedOwnership){
        assert(changedOwnership);
        return sa.owner.call();//assert.equal(fail, false, "Cant change changeOwnership");

      })
     .then(function(owner){
          assert.equal(owner, web3.eth.accounts[2], "Can change changeOwnership");
         return sa.changeOwnership(web3.eth.accounts[3], {from: web3.eth.accounts[3]});
      })
      .then(function(s){
        assert(false, " was supposed to throw but didn't.");
      //https://ethereum.stackexchange.com/questions/9103/how-can-you-handle-an-expected-throw-in-a-contract-test-using-truffle-and-ethere
      }).catch(function(error){
        return sa.owner.call();//assert.equal(fail, false, "Cant change changeOwnership");
      }).then(function(owner){
        assert.equal(owner, web3.eth.accounts[2], "Can change changeOwnership");
      });

   });






});


