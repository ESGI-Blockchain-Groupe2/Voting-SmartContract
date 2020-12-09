pragma solidity ^0.7.0;

import "./ownable.sol";

contract ElectionFactory is Ownable {
    function ElectionFactory(){}
    uint expiration = 15 days;

    struct Election {
        string title;
        Choice[] choices;
        Candidat[] candidats;
        uint totalVoters;
        bool isOpen;
        date creationDate;
        date expiresAfter;
    }

    struct Candidat {
        address id;
        string name;
        uint[] notes; // notes from 0 to 6
    }

    struct User {
        uint userId;
        bool isAdmin;

    Election[] public elections;

    mapping (uint => address) electionToOwner;
    mapping (address => uint) ownerElectionCount;
    mapping (address => User) listUser;

    modifier isAdmin(uint userId){
        require (listUser[userId].isAdmin == true);
        _;
    }

    function _addAdmin(uint userId) isAdmin(msg.sender) {
        listUser[userId].isAdmin = true
    }

    function _deleteAdmin(uint userId) isAdmin(msg.sender) {
        listUser[userId].isAdmin = false
    }

    function _createElection(string _title, string[] _candidates) external isAdmin(msg.sender)  {
        uint id = elections.push(Election(_title, _candidates, 0, true, now, expiration)) - 1;
        electionToOwner[id] = msg.sender;
        ownerElectionCount[msg.sender] ++;
        emit newElection(id);
    }


    function _closeElection(uint id) external isAdmin(msg.sender) /* isOpen(id)*/ {
        elections[id].isOpen = false;
    }

    function seeElection(uint id) external view {

    }
}
