// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.8.0;

contract Candidate {
    string public name;
    uint choiceCount;
    mapping (uint => uint) public notes;
    uint public percent;
    uint public averageNote;

    constructor(string memory _name, uint _choiceCount) {
        name = _name;
        choiceCount = _choiceCount;
    }

    function setName(string memory _name) public {
        name = _name;
    }

    function getName() public view returns (string memory) {
        return name;
    }

    function addNotes(uint note) public {
        notes[note]++;
    }

    function getAvgNote() public view returns(uint){
        return averageNote;
    }

    function getPercent() public view returns(uint){
        return percent;
    }

    function getNumberVoteForNote(uint note) public view returns(uint){
        return notes[note];
    }

    function calculatePercent(uint totalVoters, uint note) public returns(uint){
        uint numberNote = notes[note] * 100;
        uint newPercent = numberNote / totalVoters;
        return newPercent;
    }

    function computeAverageNote(uint totalVoters) public {
        for (uint i = choiceCount - 1; percent <= 50; i--){
            percent = percent + calculatePercent(totalVoters, i);
            if(percent >= 50){
                averageNote = i;
            }
        }
    }
}