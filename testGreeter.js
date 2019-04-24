var Greeter = artifacts.require("./contracts/Greeter.sol");

contract('Greeter', function (accounts) {

    it('transfer ', function () {
        return Greeter.deployed()
        .then(function (instance) {
            return instance.buyToken.call();
        })
        .then(function (result) {
            assert.isTrue(result == true);
            done();   
           
        });
    });
})
