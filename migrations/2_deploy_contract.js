const VoteContract = artifacts.require("VoteHelper");

module.exports = function(deployer) {
    deployer.deploy(VoteContract, "Hello world from VoteContract");
};