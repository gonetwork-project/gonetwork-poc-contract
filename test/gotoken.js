var SmartAsset = artifacts.require("./SmartAsset.sol");
var GoToken = artifacts.require("./GoToken.sol");

contract('GoToken', function(accounts) {
  it("calculate ppt",function(){
    var GT = null;
    return GoToken.deployed().then(function(instance){
      GT = instance;
      //1.5% of 15000
      return GT.calc_ppt.call(15000, 15);
    }).then(function(val){
      assert.equal(val.toNumber(), 225, "appropriate fee calculated")
      return GT.calc_ppt.call(1000, 15);
    }).then(function(val){
      assert.equal(val.toNumber(), 15, "calculate with smallest precision");

    });

  });

  it("should create gotoken", function() {
    var GT = null;
    var SA = null;
    var primary = web3.eth.accounts[0];
    var creator = web3.eth.accounts[1];
    var buyer1 = web3.eth.accounts[2];
    var buyer2 = web3.eth.accounts[3];
    return GoToken.deployed().then(function(instance){

      GT = instance;
      return GT.minter.call();
    }).then(function(minterAddress){
      assert.equal(minterAddress, primary, "minter address does not matche primary address");
      return SmartAsset.new(creator, 300000000000,GT.address);
    }).then(function(sa){
      SA = sa;
      assert(SA,"created mock object");

      return SA.owner.call();

    }).then(function(assetOwner){
      assert.equal(assetOwner, creator);
      return SA.tokenAddress.call();
    }).then(function(tokenAddress){
      assert.equal(tokenAddress, GT.address, "token address matches");

      return GT.transfer(buyer1, 10000000000000,{from:primary});

    }).then(function(v){
      return GT.balanceOf.call(buyer1);

    })
    .then(function(v){
      assert.equal(v.toNumber(),10000000000000);

      return GT.transfer(buyer2, 20000000000000, {from:primary});

    })
    .then(function(v){
      return GT.balanceOf.call(buyer2);

    }).then(function(v){
      assert.equal(v.toNumber(),20000000000000);
      return GT.buy(SA.address,{from:buyer1});
    })
    .then(function(v){
      assert.equal(v,true, "");
      return SA.owner.call();
    })
    .catch(function(err){
      return SA.owner.call();

    })
    .then(function(newOwner){
      assert.equal(newOwner, buyer1);
      return GT.balanceOf.call(creator);
    })

    .then(function(creatorBalance){
      assert.equal(creatorBalance.toNumber(),
      (300000000000 -(300000000000 * 0.015)) * 0.95,"minter balance");
      return GT.balanceOf.call(SA.address);
    })

    .then(function(assetStake){
      assert.equal(assetStake.toNumber(),(300000000000 -(300000000000 * 0.015)) * 0.05,"asset stake");
      return GT.balanceOf.call(primary);
    })

    .then(function(minterBalance){
      assert.equal(minterBalance.toNumber(),
        10000 * (10 ** 18)//initial supply!
         - (20000000000000 + 10000000000000)//amount transferred to buyer 2 + buyer 1 for testing
        +(300000000000 * 0.015),"asset stake");
      return GT.name.call();

    })
    .then(function(name){
       assert.equal(name, "GoToken", "Names matching");
    });

   });






});


