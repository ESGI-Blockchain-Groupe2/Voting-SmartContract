// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/ElectionFactory.sol";

contract TestElectionFactory {
    function test_election_creation() public {
        ElectionFactory electionFactory = ElectionFactory();
        string[] candidatesNames;
        candidatesNames.push("George H. W. Bush");
        candidatesNames.push("Bill Clinton");
        candidatesNames.push("Ross Perot");
        electionFactory._createElection("USA president election", candidatesNames);
        electionFactory.seeE    lection(0)
        Assert.equal(election, expected, "Election should be initialized correctly");
    }
}