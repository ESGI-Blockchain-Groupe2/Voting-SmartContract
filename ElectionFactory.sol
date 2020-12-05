pragma solidity >=0.5.0 <0.6.0;

contract ElectionFactory is Ownable {
    function ElectionFactory(){}

    struct Election {
        string titre;
        Choix[] choix;
        uint totalVoters;
        bool isOpen;
        date creationDate;
        date expiresAfter;
    }

    struct Choix {
        string titre;
        uint[] notes; // notes de 0 à 6
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

    function _closeElection(uint id) external only {

    }
}
