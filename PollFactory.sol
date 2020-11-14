pragma solidity >=0.5.0 <0.6.0;

contract PollFactory {
    function PollFactory(){}

    struct Poll {
        string title;
        string[] choices;
        int voterCount;
    }

    Poll[] public polls;

    mapping (uint => address) pollToOwner;
    mapping (address => uint) ownerPollCount;

    function _createPoll(string _title, string[] _choices) internal {
        uint id = polls.push(Poll(_title, _choices, 0)) - 1;
        pollToOwner[id] = msg.sender;
        ownerPollCount[msg.sender] ++;
        emit newPoll(id);
    }
}
