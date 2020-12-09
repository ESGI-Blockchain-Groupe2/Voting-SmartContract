pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

import "./ownable.sol";

contract ElectionFactory is Ownable {
    constructor (){}
    uint32 expiration = 15 days;

    event NewElection(uint id);

    struct Election {
        string title;
        Candidate[] candidats;
        uint totalVoters;
        bool isOpen;
        uint256 creationDate;
        uint32 expiresAfter;
    }

    struct Candidate {
        //address id;
        uint id; // TODO : Utiliser l'index du tableau candidats[] ?
        string name;
        uint[] notes; // notes from 0 to 6
    }

    struct User {
        address userAddress;
        bool isAdmin;
    }

    Election[] public elections;
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

    function _createElection(string memory _title, string[] memory _candidatesNames) external isAdmin(msg.sender)  {
        uint nbCandidates = _candidatesNames.length;

        Candidate[] memory candidates = new Candidate[](nbCandidates);
        for (uint i = 0; i < nbCandidates; i ++) {
            candidates[i] = Candidate({id: i, name: _candidatesNames[i], notes: new uint[](0)});
        }

        elections.push(Election(_title, candidates, 0, true, block.timestamp, expiration));
        uint electionId = elections.length - 1;

        electionToOwner[electionId] = msg.sender;
        ownerElectionCount[msg.sender] += 1;
        emit NewElection(electionId);
    }


    function _closeElection(uint id) external isAdmin(msg.sender) /* isOpen(id)*/ {
        elections[id].isOpen = false;
    }

    function seeElection(uint id) external view {

    }
}
