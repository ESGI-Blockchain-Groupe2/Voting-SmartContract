// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.8.0;
pragma experimental ABIEncoderV2;

import "./ownable.sol";

contract ElectionFactory is Ownable {
    constructor () {
        listAdmin[owner] = true;
    }

    uint32 expiration = 15 days;

    event NewElection(uint id);

    struct Election {
        string title;
        uint256 creationDate;
        uint256 expiresAfter;
        uint totalVoters;
        bool isOpen;

        uint candidatesCount;
        mapping (uint => Candidate) candidates;
        mapping (address => bool) voters;
        uint[] winners;
        uint winner;
    }

    struct Candidate {
        string name;
        mapping (uint => uint) notes;
        uint percent;
        uint averageNote;
    }
    uint electionsCount;
    mapping (uint => Election) public elections;
    //Election[] public elections;

    mapping (uint => address) electionToOwner;
    mapping (address => uint) ownerElectionCount;
    mapping (address => bool) listAdmin;

    modifier isAdmin(address userAddress){
        require (listAdmin[userAddress] == true);
        _;
    }

    function _addAdmin(address _userAddress) private isAdmin(msg.sender) {
        listAdmin[_userAddress]= true;
    }

    function _deleteAdmin(address _userAddress) private isAdmin(msg.sender) {
        listAdmin[_userAddress] = false;
    }


    function isUserAdmin(address userAddress) external view returns(bool){
        return listAdmin[userAddress];
    }

    /*
     * ElectionHelper.sol
     */
    function addCandidate(uint _electionId, string memory _candidateName) public {
        elections[_electionId].candidates[elections[_electionId].candidatesCount++].name = _candidateName;
    }

    function _createElection(string memory _title, string[] memory _candidatesNames) external isAdmin(msg.sender) returns (uint) {
        uint nbCandidates = _candidatesNames.length;
        electionsCount++;
        Election storage election = elections[electionsCount];
        election.title = _title;
        election.creationDate = block.timestamp;
        election.expiresAfter = expiration;
        election.totalVoters = 0;
        election.isOpen = true;

        for (uint i = 0; i < nbCandidates; i++) {
            addCandidate(electionsCount, _candidatesNames[i]);
        }

        electionToOwner[electionsCount] = msg.sender;

        ownerElectionCount[msg.sender] += 1;

        return electionsCount;
    }

    function incrementVoters(uint _electionId) public {
        elections[_electionId].totalVoters ++;
    }

    function getElectionTitle(uint _electionId) public view returns (string memory) {
        return elections[_electionId].title;
    }

    function getCandidateName(uint _electionId, uint _candidateId) public view returns (string memory) {
        return elections[_electionId].candidates[_candidateId].name;
    }
}
