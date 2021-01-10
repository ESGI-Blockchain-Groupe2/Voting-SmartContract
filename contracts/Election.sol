pragma solidity ^0.8.0;
import './Candidate.sol';

contract Election {
    string public title;
    Candidate[] public candidates;
    mapping (address => bool) voters;
    uint totalVoters;
    bool isOpen;
    uint256 creationDate;
    uint32 expiresAfter;

    constructor(string memory _title, uint256 timestamp, uint32 expiration) {
        title = _title;
        creationDate = timestamp;
        expiresAfter = expiration;
        totalVoters = 0;
        isOpen = true;
    }

    function addCandidate(string memory name) public {
        candidates.push(new Candidate(name));
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

}