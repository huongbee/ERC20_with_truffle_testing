var token02 = artifacts.require("../contracts/token02.sol");
var Greeter = artifacts.require("../contracts/Greeter.sol");

module.exports = function(deployer) {
  deployer.deploy(token02);
  deployer.deploy(Greeter,0x2e8f9e70f35771ec244810522dce583df4a85a50);
  
};