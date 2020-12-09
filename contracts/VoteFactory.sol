pragma solidity ^0.7.0;

import './ElectionFactory.sol';

contract VoteFactory is ElectionFactory {

    Election public election;

    mapping (uint => address) voteToOwner;
    mapping (uint => uint) voteToElection;

    struct Vote {
        address id;
    }

}