// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.8.0;
pragma experimental ABIEncoderV2;

import "./CandidateHelper.sol";
import "./ElectionHelper.sol";


contract VoteHelper is CandidateHelper, ElectionHelper {
    modifier hasNotVoted(uint _electionId) {
        require (!hasAlreadyVoted(_electionId), "User has already voted");
        _;
    }

    function hasAlreadyVoted(uint _electionId) public view returns (bool) {
        return elections[_electionId].voters[msg.sender];
    }

    /**
     * Gives one note to each candidates of the election
     */
    function _voteToElection(uint _electionId, uint[] calldata _notes) external hasNotVoted(_electionId) {
        require(elections[_electionId].candidatesCount == _notes.length, "Not same amount of candidates and votes");
        for (uint i = 0; i < elections[_electionId].candidatesCount; i++){
            addNote(_electionId, i, _notes[i]);
        }
        addVoter(_electionId);
    }

}