pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "./ownable.sol";
import "./Election.sol";
import "./VoteFactory.sol";

contract ElectionFactory is Ownable {
    constructor (){}
    uint32 expiration = 15 days;

    event NewElection(uint id);

    struct User {
        address userAddress;
        bool isAdmin;
    }

    mapping (uint => Election) elections;
    uint electionsSize = 0;

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

        Election election = new Election(_title, block.timestamp, expiration);
        uint electionId = electionsSize;

        //_addCandidates(electionId, nbCandidates, _candidatesNames);
        for (uint i = 0; i < nbCandidates; i ++) {
            election.addCandidate(_candidatesNames[i]);
        }
        electionsSize +=1 ;

        electionToOwner[electionId] = msg.sender;
        ownerElectionCount[msg.sender] += 1;
        emit NewElection(electionId);
    }

    /*
       TODO : Test and see if candidates are added without a mapping,
        else uncomment this and the two mapping
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
        elections[id].closeElection();
    }

    function seeElection(uint id) external view {

    }
}
