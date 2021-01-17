// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.8.0;
pragma experimental ABIEncoderV2;

import "../contracts/Election.sol";
import "../contracts/Candidate.sol";
import "../contracts/VoteFactory.sol";
import "truffle/Assert.sol";

contract TestElection {

    Election public election;

    function beforeEach() public {
        election = new Election("Test Election", block.timestamp, 1 days + uint32(block.timestamp));
    }

    function testAddCandidate() public {
        string memory candidatName = "Candidat Test";
        election.addCandidate(candidatName);
        Assert.equal(election.getCandidate(0).getName(), candidatName, "Candidate should be added to the list");
    }

    function initElectionWithVote() public {
        string memory candidateName1 = "Candidat 1";
        string memory candidatName2 = "Candidat 2";
        string memory candidateName3 = "Candidat 3";

        election.addCandidate(candidateName1);
        election.addCandidate(candidatName2);
        election.addCandidate(candidateName3);

        // First voter
        election.getCandidate(0).addNote(6);
        election.getCandidate(1).addNote(3);
        election.getCandidate(2).addNote(1);

        election.incrementVoters();

        // Second voter
        election.getCandidate(0).addNote(5);
        election.getCandidate(1).addNote(6);
        election.getCandidate(2).addNote(3);

        election.incrementVoters();

        // Third voter
        election.getCandidate(0).addNote(2);
        election.getCandidate(1).addNote(2);
        election.getCandidate(2).addNote(2);

        election.incrementVoters();
    }

    function initElectionWithVoteDraw() public {
        string memory candidateName1 = "Candidat 1";
        string memory candidateName2 = "Candidate 2";
        string memory candidateName3 = "Candidate 3";

        election.addCandidate(candidateName1);
        election.addCandidate(candidateName2);
        election.addCandidate(candidateName3);

        election.getCandidate(0).addNote(5);
        election.getCandidate(1).addNote(5);
        election.getCandidate(2).addNote(2);

        election.incrementVoters();

        election.getCandidate(0).addNote(5);
        election.getCandidate(1).addNote(6);
        election.getCandidate(2).addNote(2);

        election.incrementVoters();

        election.getCandidate(0).addNote(3);
        election.getCandidate(1).addNote(3);
        election.getCandidate(2).addNote(4);

        election.incrementVoters();
    }

    function testComputeCandidateAverageNote() public {
        initElectionWithVote();
        election.computeCandidateAverageNote();
        uint avgNote = election.getCandidate(0).getAvgNote();
        Assert.equal(avgNote, 5, "Candidate 1 should have average note of 5");
    }

    function testComputeCandidate2AverageNote() public {
        initElectionWithVote();
        election.computeCandidateAverageNote();
        uint avgNote = election.getCandidate(1).getAvgNote();
        Assert.equal(avgNote, 3, "Candidate 2 should have average note of 3");
    }

    function testComputeCandidate3AverageNote() public {
        initElectionWithVote();
        election.computeCandidateAverageNote();
        uint avgNote = election.getCandidate(2).getAvgNote();
        Assert.equal(avgNote, 2, "Candidate 3 should have average note of 2");
    }

    function testComputeFirstRoundWinnersWithoutDraw() public {
        initElectionWithVote();
        election.computeCandidateAverageNote();
        election.computeFirstRoundWinners();
        uint[] memory winners = election.getFirstRoundWinners();
        Assert.equal(winners[0], 0, "First round winner should be candidate 1 with average note of 5");
    }

    function testComputeFinalRoundWinner() public {
        initElectionWithVote();
        election.computeCandidateAverageNote();
        election.computeFirstRoundWinners();
        election.computeFinalRoundWinner();
        uint winner = election.getWinner();
        Assert.equal(winner, 0, "We should get the first candidate as winner");
    }

    function testComputeResultWithoutDraw() public {
        initElectionWithVote();
        election.computeResult();
        uint winner = election.getWinner();
        Assert.equal(winner, 0, "should return election winner index");
    }

    function testAverageNoteElectionDraw1() public {
        initElectionWithVoteDraw();
        election.computeCandidateAverageNote();
        uint avgNote = election.getCandidate(0).getAvgNote();
        Assert.equal(avgNote, 5, "avgNote should be 5");
    }

    function testAverageNoteElectionDraw2() public {
        initElectionWithVoteDraw();
        election.computeCandidateAverageNote();
        uint avgNote = election.getCandidate(1).getAvgNote();
        Assert.equal(avgNote, 5, "avgNote should be 5");
    }

    function testAverageNoteElectionDraw3() public {
        initElectionWithVoteDraw();
        election.computeCandidateAverageNote();
        uint avgNote = election.getCandidate(2).getAvgNote();
        Assert.equal(avgNote, 2, "avgNote should be 2");
    }

    function testComputeFirstRoundWinnersWithDraw() public {
        initElectionWithVoteDraw();
        election.computeCandidateAverageNote();
        election.computeFirstRoundWinners();
        uint[] memory winners = election.getFirstRoundWinners();
        Assert.equal(winners.length, 2, "We should have 2 first round winner");
    }

    function testComputeResultWithDraw() public {
        initElectionWithVoteDraw();
        election.computeResult();
        uint winner = election.getWinner();
        Assert.equal(winner, 0, "should return election winner");
    }

    

}
