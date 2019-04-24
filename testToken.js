var Token = artifacts.require("./contracts/token02.sol");

contract('Token', function (accounts) {

    it('should have 0 total token', function () {
        return Token.deployed()
        .then(function (instance) {
            return instance.totalSupply.call();
        })
        .then(function (totalSupply) {
            assert.equal(totalSupply.valueOf(), 9, 'Total token was not equal to 0');
        });
    });
    it('balance is 0', function () {
        return Token.deployed()
        .then(function (instance) {
            return instance.balanceOf.call(0x2e8f9e70f35771ec244810522dce583df4a85a50);
        })
        .then(function (balance) {
            assert.equal(balance.valueOf(),0, 'Total token was not equal to 0');
        });
    });
    // it('transfer ', function () {
    //     return Token.deployed()
    //     .then(function (instance) {
    //         return instance.buyToken.call();
    //     })
    //     .then(function (result) {
    //         assert.isTrue(result == true);
    //         done();   
           
    //     });
    // });
})
/**
 * running: truffle test testToken.js => err
 * gia lap moi truong eth: testrpc
 * compile:  truffle compile
 */