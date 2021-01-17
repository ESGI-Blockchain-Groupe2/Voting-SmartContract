// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.8.0;
pragma experimental ABIEncoderV2;

import "./ownable.sol";
import "./Election.sol";
import "./VoteFactory.sol";

contract ElectionFactory is Ownable {
    constructor (){
        listAdmin[owner] = true;
    }

    uint32 expiration = 15 days;

    event NewElection(uint id);

    Election[] elections;

    mapping (uint => address) electionToOwner;
    mapping (address => uint) ownerElectionCount;
    mapping (address => bool) listAdmin;

    modifier isAdmin(address userAddress){
        require (listAdmin[userAddress] == true);
        _;
    }

    function _addAdmin(address userAddress) private isAdmin(msg.sender) {
        listAdmin[userAddress]= true;
    }

    function _deleteAdmin(address userAddress) private isAdmin(msg.sender) {
        listAdmin[userAddress] = false;
    }


    function isUserAdmin(address userAddress) external view returns(bool){
        return listAdmin[userAddress];
    }

    function _createElection(string calldata _title, string[] calldata _candidatesNames) external isAdmin(msg.sender) {
        uint nbCandidates = _candidatesNames.length;

        
        Election election = new Election(_title, block.timestamp, expiration);


        for (uint i = 0; i < nbCandidates; i++) {
            election.addCandidate(_candidatesNames[i]);
        }

        elections.push(election);
        uint electionId = elections.length;
        
        electionToOwner[electionId] = msg.sender;

        ownerElectionCount[msg.sender] += 1;
        emit NewElection(electionId);
    }

    function _endElection(uint id) external isAdmin(msg.sender) {
        elections[id].closeElection();
        elections[id].computeResult();
    }


    function _getElections() external view returns (Election[] memory) {
        return elections;
    }


    function _getElection(uint id) external view returns (Election) {
        return elections[id];
    }
}
