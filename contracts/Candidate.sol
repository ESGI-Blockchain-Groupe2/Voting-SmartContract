pragma solidity ^0.7.0;

contract Candidate {
    string public name;
    uint[] notes; // notes from 0 to 6

    constructor(string memory _name) {
        name = _name;
    }

    function setName(string memory _name) public {
        name = _name;
    }
}