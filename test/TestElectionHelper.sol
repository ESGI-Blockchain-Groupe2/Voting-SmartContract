// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.8.0;
pragma experimental ABIEncoderV2;

import "../contracts/ElectionHelper.sol";
import "../contracts/CandidateHelper.sol";
import "../contracts/VoteHelper.sol";
import "truffle/Assert.sol";

contract TestElectionHelper is ElectionHelper {
    uint electionId;
    string[] namesList;

    function beforeEach() public {
        delete namesList;
        namesList.push("Candidate 1");
        namesList.push("Candidate 2");
        namesList.push("Candidate 3");
        electionId = this._createElection("Test Election", namesList);
    }

    function test_end_election() public {
        this.endElection(electionId);
        Assert.equal(elections[electionId].isOpen, false, "Election should be closed");
    }

    function initElectionWithVote() public {
        // First voter
        addNote(electionId, 0, 6);
        addNote(electionId, 1, 3);
        addNote(electionId, 2, 1);
        incrementVoters(electionId);

        // Second voter
        addNote(electionId, 0, 5);
        addNote(electionId, 1, 6);
        addNote(electionId, 2, 3);
        incrementVoters(electionId);

        // Third voter
        addNote(electionId, 0, 2);
        addNote(electionId, 1, 2);
        addNote(electionId, 2, 2);
        incrementVoters(electionId);
    }

    function initElectionWithVoteDraw() public {
        // First voter
        addNote(electionId, 0, 5);
        addNote(electionId, 1, 5);
        addNote(electionId, 2, 2);
        incrementVoters(electionId);

        // Second voter
        addNote(electionId, 0, 5);
        addNote(electionId, 1, 6);
        addNote(electionId, 2, 2);
        incrementVoters(electionId);

        // Third voter
        addNote(electionId, 0, 3);
        addNote(electionId, 1, 3);
        addNote(electionId, 2, 4);
        incrementVoters(electionId);
    }

    function testComputeCandidateAverageNote() public {
        initElectionWithVote();
        computeCandidatesAverageNote(electionId);
        uint avgNote = elections[electionId].candidates[0].averageNote;
        Assert.equal(avgNote, 5, "Candidate 1 should have average note of 5");
    }

    function testComputeCandidate2AverageNote() public {
        initElectionWithVote();
        computeCandidatesAverageNote(electionId);
        uint avgNote = elections[electionId].candidates[1].averageNote;
        Assert.equal(avgNote, 3, "Candidate 2 should have average note of 3");
    }

    function testComputeCandidate3AverageNote() public {
        initElectionWithVote();
        computeCandidatesAverageNote(electionId);
        uint avgNote = elections[electionId].candidates[2].averageNote;
        Assert.equal(avgNote, 2, "Candidate 3 should have average note of 2");
    }

    function testComputeFirstRoundWinnersWithoutDraw() public {
        initElectionWithVote();
        computeCandidatesAverageNote(electionId);
        computeFirstRoundWinners(electionId);
        uint[] memory winners = getFirstRoundWinners(electionId);
        Assert.equal(winners[0], 0, "First round winner should be candidate 1 with average note of 5");
    }

    function testComputeFinalRoundWinner() public {
        initElectionWithVote();
        computeCandidatesAverageNote(electionId);
        computeFirstRoundWinners(electionId);
        computeFinalRoundWinner(electionId);
        uint winner = elections[electionId].winner;
        Assert.equal(winner, 0, "We should get the first candidate as winner");
    }

    function testComputeResultWithoutDraw() public {
        initElectionWithVote();
        computeResult(electionId);
        uint winner = elections[electionId].winner;
        Assert.equal(winner, 0, "should return election winner index");
    }

    function testAverageNoteElectionDraw1() public {
        initElectionWithVoteDraw();
        computeCandidatesAverageNote(electionId);
        uint avgNote = elections[electionId].candidates[0].averageNote;
        Assert.equal(avgNote, 5, "avgNote should be 5");
    }

    function testAverageNoteElectionDraw2() public {
        initElectionWithVoteDraw();
        computeCandidatesAverageNote(electionId);
        uint avgNote = elections[electionId].candidates[1].averageNote;
        Assert.equal(avgNote, 5, "avgNote should be 5");
    }

    function testAverageNoteElectionDraw3() public {
        initElectionWithVoteDraw();
        computeCandidatesAverageNote(electionId);
        uint avgNote = elections[electionId].candidates[2].averageNote;
        Assert.equal(avgNote, 2, "avgNote should be 2");
    }

    function testComputeFirstRoundWinnersWithDraw() public {
        initElectionWithVoteDraw();
        computeCandidatesAverageNote(electionId);
        computeFirstRoundWinners(electionId);
        uint[] memory winners = getFirstRoundWinners(electionId);
        Assert.equal(winners.length, 2, "We should have 2 first round winner");
    }

    function testComputeResultWithDraw() public {
        initElectionWithVoteDraw();
        computeResult(electionId);
        uint winner = elections[electionId].winner;
        Assert.equal(winner, 0, "should return election winner");
    }

    

}
