// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.7.0 < 0.8.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Candidate.sol";

contract TestCandidate {
    Candidate public candidate;

    // Run before every test function
    function beforeEach() public {
        candidate = new Candidate("jean", 7);
    }

    function testGetNameShouldReturnCorrectName() public {
        string memory expected = "jean";
        Assert.equal(string(candidate.getName()), string(expected), "Candidate name should be jean");
    }

    function initCandidateWithNote() public {
        candidate.addNotes(5);
        candidate.addNotes(6);
        candidate.addNotes(3);
    }

    function testGetNumberNote() public {
        initCandidateWithNote();
        uint note = 5;
        uint numberNote = candidate.getNumberVoteForNote(note);
        Assert.equal(numberNote, 1, "Note 5 should've been chosen once");
    }

    function testCalculatePercent() public {
        initCandidateWithNote();
        uint percent = candidate.calculatePercent(3, 3);
        Assert.equal(percent, 33, "Percent of voters voting for note 5");
    }

    function testComputeAverageNote() public {
        initCandidateWithNote();
        candidate.computeAverageNote(3);
        Assert.equal(candidate.getAvgNote(), 5, "Candidate average note should be 5");
    }
}