// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.7.0 < 0.8.0;
pragma experimental ABIEncoderV2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/CandidateHelper.sol";
import "../contracts/ElectionFactory.sol";

contract TestCandidateHelper is CandidateHelper {
    uint electionId;
    uint candidatesCount;
    string[] nameList;
    uint[] notes;
    // Run before every test function
    function beforeEach() public {
        delete nameList;
        delete notes;
        nameList.push("Jean");
        nameList.push("Michel");
        nameList.push("Bernard");

        notes.push(5);
        notes.push(4);
        notes.push(3);

        candidatesCount = nameList.length;
        electionId = this._createElection("Test election", nameList);
    }

    function voteForCandidates(uint[] memory _notes) internal {
        require(candidatesCount == _notes.length, "Not same amount of candidates and votes");
        for (uint candidateId = 0; candidateId < candidatesCount; candidateId ++) {
            addNote(electionId, candidateId, _notes[candidateId]);
        }
    }

    function testName() public {
        string memory expected = "Jean";
        Assert.equal(string(elections[electionId].candidates[0].name), string(expected), "Candidate name should be jean");
    }

    function testAddNotes() public {
        voteForCandidates(notes);
        uint result = elections[electionId].candidates[0].notes[5];
        Assert.equal(result, 1, "Note 5 should've been chosen once");
    }

    function testCalculatePercent() public {
        voteForCandidates(notes);

        uint candidateId = 0;
        uint percent = calculatePercent(electionId, candidateId, 5);
        Assert.equal(percent, 33, "Percent of voters voting 5 for candidate Jean");
    }

    function testComputeAverageNote() public {
        voteForCandidates(notes);
        computeAverageNote(electionId, 0);
        Assert.equal(elections[electionId].candidates[0].averageNote, 5, "Candidate average note should be 5");
    }
}