// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.7.0 < 0.8.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/CandidateHelper.sol";
import "../contracts/ElectionFactory.sol";

contract TestCandidateHelper is CandidateHelper {
    uint electionId;
    uint candidatesCount;
    // Run before every test function
    function beforeEach() public {
        string[] memory candidates = ["Jean", "Michel", "Bernard"];
        candidatesCount = candidates.length;
        electionId = this._createElection("Test election", candidates);
    }

    function voteForCandidates(uint[] memory _notes) internal {
        require(candidatesCount == _notes.length, "Not same amount of candidates and votes");
        for (uint candidateId = 0; candidateId < candidatesCount; candidateId ++) {
            addNote(electionId, candidateId, _notes[candidateId]);
        }
    }

    function testName() public {
        string memory expected = "Jean";
        Assert.equal(string(elections[electionId].name), string(expected), "Candidate name should be jean");
    }

    function testAddNotes() public {
        uint noteCandidate1 = 5;
        voteForCandidates([noteCandidate1, 4, 3]);
        uint result = elections[electionId].candidates[0].notes[noteCandidate1];
        Assert.equal(result, 1, "Note 5 should've been chosen once");
    }

    function testCalculatePercent() public {
        voteForCandidates([6, 4, 5]);

        uint candidateId = 0;
        uint percent = calculatePercent(electionId, candidateId, 5);
        Assert.equal(percent, 33, "Percent of voters voting 5 for candidate Jean");
    }

    function testComputeAverageNote() public {
        voteForCandidates([5, 4, 6]);
        computeAverageNote(electionId, 0);
        Assert.equal(elections[electionId].candidates[0].averageNote, 5, "Candidate average note should be 5");
    }
}