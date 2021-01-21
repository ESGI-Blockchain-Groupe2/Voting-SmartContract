const VoteContract = artifacts.require("Vote");

module.exports = function(deployer) {
    deployer.deploy(VoteContract, "Hello world from Vote Contract");
};