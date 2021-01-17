// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.8.0;

import "truffle/Assert.sol";
import "../contracts/Election.sol";
import "../contracts/Candidate.sol";
import "../contracts/VoteFactory.sol";

contract TestVoteFactory {
    VoteFactory internal voteFactory;
    Election public election;
    //Candidate[] public candidates;
    uint[] notes;
    // Run before every test function
    function beforeEach() public {
        delete election;
        election = new Election();
        election.init("TestElection", block.timestamp, 15 days);
        delete voteFactory;
        voteFactory = new VoteFactory();
        voteFactory.init(election);
        delete notes;
    }

    function generateNotesForElection(Election _election) internal returns (uint[] memory) {
        uint[] memory generatedNotes = new uint[](_election.getNumberOfCandidates());
        for (uint i = 0; i < _election.getNumberOfCandidates(); i++) {
            uint256 generatedNote = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 7;
            generatedNotes[i] = generatedNote;
            notes.push(generatedNote);
        }
        return generatedNotes;
    }

    function addSixCandidates(Election _election) internal {
        _election.addCandidate("Jean");
        _election.addCandidate("Michelle");
        _election.addCandidate("Norah");
        _election.addCandidate("Alexandre");
        _election.addCandidate("Marc");
        _election.addCandidate("Pierre");
    }

    function checkIfNotesAreAdded(uint[] memory notesSupposedlyAdded, Election _election) internal view returns (bool) {
        for (uint i; i < election.getNumberOfCandidates(); i++) {
            if (_election.getCandidate(i).getNote(notesSupposedlyAdded[i]) != 1) {
                return false;
            }
        }
        return true;
    }

    function test_WhenUserHasVoted_AlreadyVoteReturnsTrue() public {
        addSixCandidates(election);
        uint[] memory generatedNotes = generateNotesForElection(election);

        voteFactory._voteToElection(generatedNotes);
        Assert.equal(election.alreadyVote(), true, "This user already voted");
    }

    function test_WhenUserHasNotVoted_AlreadyVoteReturnsFalse() public {
        Assert.equal(election.alreadyVote(), false, "This user has not voted");
    }

    function test_WhenUserHasVoted_NotesAreAddedToCandidates() public {
        addSixCandidates(election);
        uint[] memory generatedNotes = generateNotesForElection(election);

        voteFactory._voteToElection(generatedNotes);

        bool notesAreAdded = checkIfNotesAreAdded(generatedNotes, election);
        Assert.equal(bool(notesAreAdded), bool(true), "Notes should be added to candidates");


    }
}
