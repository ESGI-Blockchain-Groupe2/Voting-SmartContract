// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.8.0;
pragma experimental ABIEncoderV2;

import "truffle/Assert.sol";
import "../contracts/ElectionHelper.sol";
import "../contracts/CandidateHelper.sol";
import "../contracts/VoteHelper.sol";
import "../contracts/ElectionFactory.sol";

contract TestVoteHelper is VoteHelper {
    uint electionId;
    string[] namesList;

    // Run before every test function
    function beforeEach() public {
        delete namesList;
        namesList.push("Candidate 1");
        namesList.push("Candidate 2");
        namesList.push("Candidate 3");
        electionId = this._createElection("TestElection", namesList);
    }

    /*function voteForCandidates(uint[] calldata _notes) internal {
        require(elections[electionId].candidatesCount == _notes.length, "Not same amount of candidates and votes");
        for (uint candidateId = 0; candidateId < elections[electionId].candidatesCount; candidateId ++) {
            addNote(electionId, candidateId, _notes[candidateId]);
        }
    }*/

    function addSixCandidates() internal {
        addCandidate(electionId, "Jean");
        addCandidate(electionId, "Michelle");
        addCandidate(electionId, "Norah");
        addCandidate(electionId, "Alexandre");
        addCandidate(electionId, "Marc");
        addCandidate(electionId, "Pierre");
    }

    /*function generateVotesForElection() internal returns (uint[] memory) {
        uint[] memory generatedNotes = new uint[](elections[electionId].candidatesCount);
        for (uint i = 0; i < elections[electionId].candidatesCount; i++) {
            uint256 generatedNote = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 7;
            generatedNotes[i] = generatedNote;
        }
        return generatedNotes;
    }*/

    function checkIfNotesAreAdded(uint[] memory notesSupposedlyAdded) internal view returns (bool) {
        for (uint i; i < elections[electionId].candidatesCount; i++) {
            if (elections[electionId].candidates[i].notes[notesSupposedlyAdded[i]] != 1) {
                return false;
            }
        }
        return true;
    }

    function test_WhenUserHasVoted_HasAlreadyVotedReturnsTrue() public {
        addSixCandidates();
        //uint[] memory notes = generateVotesForElection();
        uint[] memory notes = new uint[](6);
        notes[0] = 1;
        notes[1] = 5;
        notes[2] = 6;
        notes[3] = 4;
        notes[4] = 4;
        notes[5] = 3;
        this._voteToElection(electionId, notes);
        Assert.equal(hasAlreadyVoted(electionId), true, "This user already voted");
    }

    function test_WhenUserHasNotVoted_HasAlreadyVotedReturnsFalse() public {
        Assert.equal(hasAlreadyVoted(electionId), false, "This user has not voted");
    }

    function test_WhenUserHasVoted_NotesAreAddedToCandidates() public {
        addSixCandidates();
        uint[] memory notes = new uint[](6);
        notes[0] = 1;
        notes[1] = 5;
        notes[2] = 6;
        notes[3] = 4;
        notes[4] = 4;
        notes[5] = 3;
        //uint[] memory generatedNotes = generateVotesForElection();

        this._voteToElection(electionId, notes);

        bool notesAreAdded = checkIfNotesAreAdded(notes);
        Assert.equal(bool(notesAreAdded), bool(true), "Notes should be added to candidates");


    }
}
