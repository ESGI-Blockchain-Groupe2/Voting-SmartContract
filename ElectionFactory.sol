pragma solidity ^0.7.0;

contract ElectionFactory {

    struct Election {
        string titre;
        Candidat[] candidats;
        uint totalVoters;
        bool isOpen;
        date creationDate;
        date expiresAfter;
    }

    struct Candidat {
        address id;
        string name;
    }

    struct Mention {
        string name;
        uint value;
    }

    Election[] public elections;

    mapping (uint => address) electionToOwner;
    mapping (address => uint) ownerElectionCount;

    function _createElection(string _title, string[] _choices) internal {
        uint id = elections.push(Election(_title, _choices, 0)) - 1;
        electionToOwner[id] = msg.sender;
        ownerElectionCount[msg.sender] ++;
        emit newElection(id);
    }
}
