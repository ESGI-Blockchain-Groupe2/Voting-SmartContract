// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.7.0 < 0.8.0;
pragma experimental ABIEncoderV2;

import "truffle/Assert.sol";
import "../contracts/CandidateHelper.sol";

contract TestCandidateHelper {
    CandidateHelper voteContract;
    uint electionId;
    uint candidatesCount;
    string[] nameList;
    uint[] notes;
    uint[] notes2;
    uint[] notes3;

    // Run before every test function
    function beforeEach() public {
        delete nameList;
        delete notes;
        nameList.push("Jean");
        nameList.push("Michel");
        nameList.push("Bernard");

        voteContract = new CandidateHelper();

        electionId = voteContract._createElection("Test election", nameList);
        candidatesCount = voteContract.getCandidatesCount(electionId);
    }

    function voteForCandidates(uint[] memory _notes) internal {
        require(candidatesCount == _notes.length, "Not same amount of candidates and votes");
        for (uint candidateId = 0; candidateId < candidatesCount; candidateId ++) {
            voteContract.addNote(electionId, candidateId, _notes[candidateId]);
        }
        voteContract.incrementVoters(electionId);
    }

    function testName() public {
        string memory expected = "Jean";
        Assert.equal(string(voteContract.getCandidateName(electionId, 0)), string(expected), "Candidate name should be jean");
    }

    function testAddNotes() public {
        notes.push(5);
        notes.push(4);
        notes.push(3);
        voteForCandidates(notes);
        uint result = voteContract.getCandidateNote(electionId, 0, 5);
        Assert.equal(result, 1, "Note 5 should've been chosen once");
    }

    function testCalculatePercent() public {
        notes.push(5);
        notes.push(4);
        notes.push(3);

        notes2.push(6);
        notes2.push(4);
        notes2.push(1);

        notes3.push(1);
        notes3.push(2);
        notes3.push(3);

        voteForCandidates(notes);
        voteForCandidates(notes2);
        voteForCandidates(notes3);

        uint candidateId = 0;
        uint percent = voteContract.calculatePercent(electionId, candidateId, 5);
        Assert.equal(percent, 33, "Percent of voters voting 5 for candidate Jean");
    }

    function testComputeAverageNote() public {
        notes.push(5);
        notes.push(4);
        notes.push(6);
        voteForCandidates(notes);
        voteContract.computeAverageNote(electionId, 0);
        Assert.equal(voteContract.getCandidateAverageNote(electionId, 0), 5, "Candidate average note should be 5");
    }
}