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
        election.getCandidate(0).addNotes(6);
        election.getCandidate(1).addNotes(3);
        election.getCandidate(2).addNotes(1);

        // Second voter
        election.getCandidate(0).addNotes(5);
        election.getCandidate(1).addNotes(6);
        election.getCandidate(2).addNotes(3);

        // Third voter
        election.getCandidate(0).addNotes(2);
        election.getCandidate(1).addNotes(2);
        election.getCandidate(2).addNotes(2);
        
    }

    function testComputeFirstRoundWinners() public {
        initElectionWithVote();
        election.computeFirstRoundWinners();
    }

    function testComputeFinalRoundWinner() public {
        initElectionWithVote();
        election.computeFirstRoundWinners();
    }

    function testComputeResultWithoutDraw() public {
        initElectionWithVote();
        election.computeResult();
        Assert.equal(election.getWinner(), 1, "should return election winner index");
    }

    

}
