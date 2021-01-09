// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

import "./ownable.sol";

contract ElectionFactory is Ownable {
    constructor (){}
    uint32 expiration = 15 days;

    event NewElection(uint id);

    struct Election {
        string title;
        /*
            TODO : Test and see if candidates are added without a mapping,
             else uncomment the two parameters below and _addCandidates
        */
        //mapping (uint => Candidate) candidates;
        //uint candidatesSize;
        Candidate[] candidates;
        uint totalVoters;
        bool isOpen;
        uint256 creationDate;
        uint32 expiresAfter;
    }

    struct Candidate {
        uint id; // TODO : Utiliser l'index du tableau candidats[] ?
        string name;
        uint[] notes; // notes from 0 to 6
    }

    struct User {
        address userAddress;
        bool isAdmin;
    }

    /*mapping (uint => Election) elections;
    uint electionsSize = 0;*/
    Election[] elections;
    User[] users;

    mapping (uint => address) electionToOwner;
    mapping (address => uint) ownerElectionCount;
    mapping (address => User) listUser;

    modifier isAdmin(address userAddress){
        require (listUser[userAddress].isAdmin == true);
        _;
    }

    function _addAdmin(address userAddress) private isAdmin(msg.sender) {
        listUser[userAddress].isAdmin = true;
    }

    function _deleteAdmin(address userAddress) private isAdmin(msg.sender) {
        listUser[userAddress].isAdmin = false;
    }

    // TODO : function addUser

    function _createElection(string calldata _title, string[] calldata _candidatesNames) external isAdmin(msg.sender)  {
        uint nbCandidates = _candidatesNames.length;
        Election storage election = elections[elections.length];
        uint electionId = elections.length;

        election.title = _title;
        election.totalVoters = 0;
        election.isOpen = true;
        election.creationDate = block.timestamp;
        election.expiresAfter = expiration;

        //_addCandidates(electionId, nbCandidates, _candidatesNames);
        for (uint i = 0; i < nbCandidates; i ++) {
            election.candidates[election.candidates.length] = Candidate(i, _candidatesNames[i], new uint[](0));
        }

        electionToOwner[electionId] = msg.sender;
        ownerElectionCount[msg.sender] += 1;
        emit NewElection(electionId);
    }

    /*
       TODO : Test and see if candidates are added without a mapping,
        else uncomment this and the two commented parameters in struct
    */
    /*function _addCandidates(uint electionId, uint nbCandidates, string[] calldata _candidatesNames) internal {
        Election storage e = elections[electionId];

        for (uint i = 0; i < nbCandidates; i ++) {
            //elections[electionId].candidates[i] = Candidate({id: i, name: _candidatesNames[i], notes: new uint[](0)});
            e.candidates[e.candidatesSize] = Candidate(i, _candidatesNames[i], new uint[](0));
        }

        e.candidatesSize++;
    }*/


    function _closeElection(uint id) external isAdmin(msg.sender) /* isOpen(id)*/ {
        elections[id].isOpen = false;
    }

    function seeElection(uint id) external view {

    }
}
