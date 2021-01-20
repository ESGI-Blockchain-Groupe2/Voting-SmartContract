// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.8.0;
pragma experimental ABIEncoderV2;

import "./ElectionFactory.sol";


contract CandidateHelper is ElectionFactory {
    function addNote(uint _electionId, uint _candidateId, uint note) public {
        elections[_electionId].candidates[_candidateId].notes[note] ++;
        //notes[note]++;
    }





    function calculatePercent(uint _electionId, uint _candidateId, uint _note) public view returns(uint){
        uint notes = elections[_electionId].candidates[_candidateId].notes[_note];
        uint numberNote = notes * 100;
        uint newPercent = numberNote / elections[_electionId].totalVoters;
        return newPercent;
    }

    function computeAverageNote(uint _electionId, uint _candidateId) public {
        if (elections[_electionId].totalVoters == 0) {
            elections[_electionId].candidates[_candidateId].averageNote = 0;
        }
        else {
            uint percent = elections[_electionId].candidates[_candidateId].percent;
            for (uint i = 6; percent <= 50; i--){
                elections[_electionId].candidates[_candidateId].percent = percent + calculatePercent(_electionId, _candidateId, i);
                if(percent >= 50){
                    elections[_electionId].candidates[_candidateId].averageNote = i;
                }
              }
            }
    }
}