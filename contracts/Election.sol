// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.8.0;
import './Candidate.sol';

contract Election {
    string public title;
    Candidate[] public candidates;
    mapping (address => bool) voters;
    uint totalVoters;
    bool isOpen;
    uint256 creationDate;
    uint256 expiresAfter;

    uint[] winners;
    uint choiceCount;
    uint winner;

    constructor(string memory _title, uint256 timestamp, uint32 expiration) {
        title = _title;
        creationDate = timestamp;
        expiresAfter = expiration;
        totalVoters = 0;
        isOpen = true;
        choiceCount = 7;
    }

    function addCandidate(string memory name) public {
        candidates.push(new Candidate(name, choiceCount));
    }

    function setTitle(string memory newTitle) public {
        title = newTitle;
    }

    function closeElection() public {
        isOpen = false;
    }

    function incrementVoters() public {
        totalVoters++;
    }

    function addVoter() public {
        voters[msg.sender] = true;
    }

    function alreadyVote() public view returns (bool){
        return voters[msg.sender];
    }

    function getCandidate(uint id) public view returns (Candidate){
        return candidates[id];
    }

    function getWinner() public view returns (uint){
        return winner;
    }

    function computeResult() public {
        for (uint i = 0; i < candidates.length; i++){
            candidates[i].computeAverageNote(totalVoters);
        }

        computeFirstRoundWinners();

        if(winners.length > 1){
            computeFinalRoundWinner();
        }
        else {
            winner = winners[0];
        }
    }

    function computeFirstRoundWinners() public {
        uint higherNote = 0;
        for(uint i = 0; i < candidates.length; i++){
            if(higherNote == candidates[i].getAvgNote()){
                winners.push(i);
            }
            else if(higherNote < candidates[i].getAvgNote()){
                delete winners;
                winners.push(i);
            }
        }
    }

    function computeFinalRoundWinner() public {
        uint higherPercent;
        for(uint i = 0; i < winners.length; i++){
            uint currentPercent = candidates[winners[i]].getPercent();
            if(i == 0){
                higherPercent = currentPercent;
                winner = winners[i];
            }
            else if (currentPercent > higherPercent){
                higherPercent = currentPercent;
                winner = winners[i];
            }
        }
    }
}
