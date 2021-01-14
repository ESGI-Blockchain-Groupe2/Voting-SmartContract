pragma solidity ^0.8.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Candidate.sol";

contract TestCandidate {
    Candidate public candidate;

    // Run before every test function
    function beforeEach() public {
        candidate = new Candidate();
    }

    function testComputeAverageNote() public {
        uint choicecount = 10;
        uint percent = 45;
        uint result = candidate.getPercent(percent);
    }
}
