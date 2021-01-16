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

    function _voteToElection(uint electionId, uint[] calldata notes) external {
        require(election.alreadyVote() == false);
        for (uint i = 0; i < notes.length; i++){
            election.candidates(i).addNotes(notes[i]);
        }
        election.addVoter();
        election.incrementVoters();
        emit NewVote(electionId);
    }

}