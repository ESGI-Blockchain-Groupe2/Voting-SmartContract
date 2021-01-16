// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.7.0 < 0.8.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Candidate.sol";
import "../c

contract TestCandidate {
    Candidate public candidate;

    // Run before every test function
    function beforeEach() public {
        candidate = new Candidate("jean", 2);
    }

    function testNameIsCorrect() public {
        Assert.equal(bytes(candidate.name), string("jean"), "Candidate name should be jean");
    }
    function testgetAvgNote() public {

    }

    function testComputeAverageNote() public {
        //uint choicecount = 10;
        //uint percent = 45;
        //uint result = candidate.getPercent();
    }
}