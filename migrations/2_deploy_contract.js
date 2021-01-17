const Candidate = artifacts.require("Candidate");
const Election = artifacts.require("Election");
const ElectionFactory = artifacts.require("ElectionFactory");
//const ElectionHelper = artifacts.require("ElectionHelper");
const VoteFactory = artifacts.require("VoteFactory");
//const Ownable = artifacts.require("Ownable");

module.exports = function(deployer) {
    deployer.deploy(Candidate);
    deployer.deploy(Election);
    deployer.deploy(ElectionFactory);
    deployer.deploy(VoteFactory);

};