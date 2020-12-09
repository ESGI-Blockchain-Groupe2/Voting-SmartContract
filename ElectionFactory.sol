pragma solidity >=0.5.0 <0.6.0;

import "./ownable.sol";

contract ElectionFactory is Ownable {
    function ElectionFactory(){}
    uint expiration = 15 days;

    struct Election {
        string title;
        Choice[] choices;
        uint totalVoters;
        bool isOpen;
        date creationDate;
        date expiresAfter;
    }

    struct User {
        uint userId;
        bool isAdmin;

    struct Choice {
        string title;
        uint[] notes; // notes from 0 to 6
    }

    Election[] public elections;

    mapping (uint => address) electionToOwner;
    mapping (address => uint) ownerElectionCount;

    function _createElection(string _title, string[] _choices) external /*onlyAdmin*/ {
        uint id = elections.push(Election(_title, _choices, 0, true, now, expiration)) - 1;
        electionToOwner[id] = msg.sender;
        ownerElectionCount[msg.sender] ++;
        emit newElection(id);
    }


    mapping (address => User) listUser;

    modifier isAdmin(uint userId){
        require (userId);
        _;
    }

    function _addAdmin(uint userId) isAdmin(_userId) {
        listUser[userId].isAdmin = true
    }

    function _deleteAdmin(uint userId) isAdmin(_userId) {
        listUser[userId].isAdmin = false

    function _closeElection(uint id) external /*onlyAdmin isOpen(id)*/ {
        elections[id].isOpen = false;
    }

    function seeElection(uint id) external view {

    }
}
