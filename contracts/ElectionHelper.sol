pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

import "./ElectionFactory.sol";

contract ElectionHelper is ElectionFactory {
    constructor() {}

    function changeTitle(uint _electionId, string calldata _newTitle) external isAdmin(msg.sender) {
        elections[_electionId].title = _newTitle;
    }

    function changeCandidateName(uint _electionId, uint _candidateId, string calldata _newName) external isAdmin(msg.sender) {
        elections[_electionId].candidats[_candidateId].name = _newName;
    }
}
