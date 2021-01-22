// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.8.0;
pragma experimental ABIEncoderV2;

import "../contracts/ElectionHelper.sol";
import "truffle/Assert.sol";

contract TestElectionHelper {
    ElectionHelper voteContract;
    uint electionId;
    string[] namesList;

    function beforeEach() public {
        delete namesList;
        namesList.push("Candidate 1");
        namesList.push("Candidate 2");
        namesList.push("Candidate 3");

        voteContract = new ElectionHelper();
        electionId = voteContract.createElection("Test Election", namesList);
    }

    function testEndElection() public {
        voteContract.endElection(electionId);
        Assert.equal(voteContract.getElectionStatus(electionId), false, "Election should be closed");
    }

    function testElectionCreation() public {
        Assert.equal(string(voteContract.getElectionTitle(electionId)), string("Test Election"), "Title of the first election should be USA president election");
    }

    function initElectionWithVote() public {
        // First voter
        voteContract.addNote(electionId, 0, 6);
        voteContract.addNote(electionId, 1, 3);
        voteContract.addNote(electionId, 2, 1);
        voteContract.incrementVoters(electionId);

        // Second voter
        voteContract.addNote(electionId, 0, 5);
        voteContract.addNote(electionId, 1, 6);
        voteContract.addNote(electionId, 2, 3);
        voteContract.incrementVoters(electionId);

        // Third voter
        voteContract.addNote(electionId, 0, 2);
        voteContract.addNote(electionId, 1, 2);
        voteContract.addNote(electionId, 2, 2);
        voteContract.incrementVoters(electionId);
    }

    function initElectionWithVoteDraw() public {
        // First voter
        voteContract.addNote(electionId, 0, 5);
        voteContract.addNote(electionId, 1, 5);
        voteContract.addNote(electionId, 2, 2);
        voteContract.incrementVoters(electionId);

        // Second voter
        voteContract.addNote(electionId, 0, 5);
        voteContract.addNote(electionId, 1, 6);
        voteContract.addNote(electionId, 2, 2);
        voteContract.incrementVoters(electionId);

        // Third voter
        voteContract.addNote(electionId, 0, 3);
        voteContract.addNote(electionId, 1, 3);
        voteContract.addNote(electionId, 2, 4);
        voteContract.incrementVoters(electionId);
    }

    function testComputeCandidateAverageNote() public {
        initElectionWithVote();
        voteContract.computeCandidatesAverageNote(electionId);
        ( , , uint averageNote) = voteContract.getCandidate(electionId, 0);
        Assert.equal(averageNote, 5, "Candidate 1 should have average note of 5");
    }

    function testComputeCandidate2AverageNote() public {
        initElectionWithVote();
        voteContract.computeCandidatesAverageNote(electionId);
        ( , , uint averageNote) = voteContract.getCandidate(electionId, 1);
        Assert.equal(averageNote, 3, "Candidate 2 should have average note of 3");
    }

    function testComputeCandidate3AverageNote() public {
        initElectionWithVote();
        voteContract.computeCandidatesAverageNote(electionId);
        ( , , uint averageNote) = voteContract.getCandidate(electionId, 2);
        Assert.equal(averageNote, 2, "Candidate 3 should have average note of 2");
    }

    function testComputeFirstRoundWinnersWithoutDraw() public {
        initElectionWithVote();
        voteContract.computeCandidatesAverageNote(electionId);
        voteContract.computeFirstRoundWinners(electionId);
        uint[] memory winners = voteContract.getFirstRoundWinners(electionId);
        Assert.equal(winners[0], 0, "First round winner should be candidate 1 with average note of 5");
    }

    function testComputeFinalRoundWinner() public {
        initElectionWithVote();
        voteContract.computeCandidatesAverageNote(electionId);
        voteContract.computeFirstRoundWinners(electionId);
        voteContract.computeFinalRoundWinner(electionId);
        uint winner = voteContract.getElectionWinner(electionId);
        Assert.equal(winner, 0, "We should get the first candidate as winner");
    }

    function testComputeResultWithoutDraw() public {
        initElectionWithVote();
        bool isTie = voteContract.computeResult(electionId);
        Assert.equal(isTie, false, "Should return false as there is supposed to be no draw");
    }

    function testAverageNoteElectionDraw1() public {
        initElectionWithVoteDraw();
        voteContract.computeCandidatesAverageNote(electionId);
        ( , , uint averageNote) = voteContract.getCandidate(electionId, 0);
        Assert.equal(averageNote, 5, "avgNote should be 5");
    }

    function testAverageNoteElectionDraw2() public {
        initElectionWithVoteDraw();
        voteContract.computeCandidatesAverageNote(electionId);
        ( , , uint averageNote) = voteContract.getCandidate(electionId, 1);
        Assert.equal(averageNote, 5, "avgNote should be 5");
    }

    function testAverageNoteElectionDraw3() public {
        initElectionWithVoteDraw();
        voteContract.computeCandidatesAverageNote(electionId);
        ( , , uint averageNote) = voteContract.getCandidate(electionId, 2);
        Assert.equal(averageNote, 2, "avgNote should be 2");
    }

    function testComputeFirstRoundWinnersWithDraw() public {
        initElectionWithVoteDraw();
        voteContract.computeCandidatesAverageNote(electionId);
        voteContract.computeFirstRoundWinners(electionId);
        uint[] memory winners = voteContract.getFirstRoundWinners(electionId);
        Assert.equal(winners.length, 2, "We should have 2 first round winner");
    }

    function testComputeResultWithDraw() public {
        initElectionWithVoteDraw();
        bool isTie = voteContract.computeResult(electionId);
        Assert.equal(isTie, true, "Should return true as there is supposed to be a draw");
    }
}
