// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "./ElectionFactory.sol";

contract ElectionHelper is ElectionFactory {
    constructor() {}

    function changeTitle(uint _electionId, string calldata _newTitle) external isAdmin(msg.sender) {
        elections[_electionId].setTitle(_newTitle);
    }

    function changeCandidateName(uint _electionId, uint _candidateId, string calldata _newName) external isAdmin(msg.sender) {
        elections[_electionId].candidates(_candidateId).setName(_newName);
    }
}
