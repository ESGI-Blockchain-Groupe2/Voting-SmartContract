// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.7.0 < 0.8.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/ElectionFactory.sol";
import "../contracts/CandidateHelper.sol";

contract TestCandidate {
    CandidateHelper candidateHelper;
    Candidate candidate;
    // Run before every test function
    function beforeEach() public {
        candidate = Candidate("jean", 7);
    }

    function testGetNameShouldReturnCorrectName() public {
        string memory expected = "jean";
        Assert.equal(string(candidate.name), string(expected), "Candidate name should be jean");
    }

    function initCandidateWithNote() public {
        candidateHelper.addNoteToCandidate(0, 0, 5)
        candidate.addNote(5);
        candidate.addNote(6);
        candidate.addNote(3);
    }

    function testGetNumberNote() public {
        initCandidateWithNote();
        uint note = 5;
        uint numberNote = elections[_electionId].candidates[_candidateId].notes[note];
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