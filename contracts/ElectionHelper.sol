// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.8.0;
pragma experimental ABIEncoderV2;

import './CandidateHelper.sol';
import "./ownable.sol";
import "./ElectionFactory.sol";


contract ElectionHelper is ElectionFactory, CandidateHelper {
    function endElection(uint _electionId) external isAdmin(msg.sender) {
        elections[_electionId].isOpen = false;
        computeResult(_electionId);
    }

    function getElectionStatus(uint _electionId) public view returns (bool) {
        return elections[_electionId].isOpen;
    }

    function getElectionWinner(uint _electionId) public view returns (uint) {
        return elections[_electionId].winner;
    }

    function addVoter(uint _electionId) public {
        elections[_electionId].voters[msg.sender] = true;
        incrementVoters(_electionId);
    }

    function getOneFirstRoundWinner(uint _electionId, uint _index) public view returns(uint){
        return elections[_electionId].winners[_index];
    }

    function getFirstRoundWinners(uint _electionId) public view returns(uint[] memory){
        return elections[_electionId].winners;
    }

    function computeResult(uint _electionId) public {
        computeCandidatesAverageNote(_electionId);

        computeFirstRoundWinners(_electionId);

        computeFinalRoundWinner(_electionId);
        if(elections[_electionId].winners.length > 1){
            computeFinalRoundWinner(_electionId);
        }
        else { // Default case if tie
            elections[_electionId].winner = elections[_electionId].winners[0];
        }
    }

    function computeCandidatesAverageNote(uint _electionId) public {
        for (uint i = 0; i < elections[_electionId].candidatesCount; i++){
            computeAverageNote(_electionId, i);
        }
    }

    function computeFirstRoundWinners(uint _electionId) public {
        uint higherNote = 0;
        for(uint i = 0; i < elections[_electionId].candidatesCount; i++){
            if(higherNote == elections[_electionId].candidates[i].averageNote){
                elections[_electionId].winners.push(i);
            }
            else if(higherNote < elections[_electionId].candidates[i].averageNote){
                delete elections[_electionId].winners;
                higherNote = elections[_electionId].candidates[i].averageNote;
                elections[_electionId].winners.push(i);
            }
        }
    }

    function computeFinalRoundWinner(uint _electionId) public {
        uint higherPercent;
        for(uint i = 0; i < elections[_electionId].winners.length; i++){
            uint currentPercent = elections[_electionId].candidates[elections[_electionId].winners[i]].percent;
            if(i == 0){
                higherPercent = currentPercent;
                elections[_electionId].winner = elections[_electionId].winners[i];
            }
            else if (currentPercent > higherPercent){
                higherPercent = currentPercent;
                elections[_electionId].winner = elections[_electionId].winners[i];
            }
        }
    }
}
