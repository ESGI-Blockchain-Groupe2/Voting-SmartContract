pragma solidity ^0.8.0;

contract Candidate {
    string public name;
    uint[] notes; // notes from 0 to 6

    constructor(string memory _name) {
        name = _name;
    }

    function setName(string memory _name) public {
        name = _name;
    }

    function addNotes(uint note) public {
        notes.push(note);
    }
}