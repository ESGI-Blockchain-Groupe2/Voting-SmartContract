// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.8.0;
pragma experimental ABIEncoderV2;

import "./Election.sol";

contract VoteFactory {

    constructor(Election _election) {
        election = _election;
    }

    Election public election;

    event NewVote(uint electionId);

    modifier hasNotVoted(address userAddress){
        require (!election.alreadyVote(), "User has already voted");
        _;
    }

    /**
     * Gives one note to each candidates of the election
     */
    function _voteToElection(uint[] calldata notes) external hasNotVoted(msg.sender) {
        require(election.getNumberOfCandidates() == notes.length, "Not same amount of candidates and votes");
        for (uint i = 0; i < election.getNumberOfCandidates(); i++){
            election.candidates(i).addNote(notes[i]);
        }
        election.addVoter(msg.sender);
    }

}