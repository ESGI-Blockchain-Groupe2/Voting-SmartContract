// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.8.0;
pragma experimental ABIEncoderV2;

import "truffle/DeployedAddresses.sol";
import "../contracts/ElectionFactory.sol";

contract TestElectionFactory {
    //string[] candidatesNames;
    //ElectionFactory.Candidate[] expectedCandidates;

    /*function test_election_creation() public {
        string[] memory candidatesNames = new string[](3);
        ElectionFactory.Candidate[] memory expectedCandidates = new ElectionFactory.Candidate[](3);
        ElectionFactory electionFactory = new ElectionFactory();
        candidatesNames[0] = "George H. W. Bush";
        candidatesNames[1] = "Bill Clinton";
        candidatesNames[2] = "Ross Perot";
        electionFactory._createElection("USA president election", candidatesNames);

        //expectedCandidates[0] = ElectionFactory.Candidate(1, "George H. W. Bush", new uint8[](0));
        //    ElectionFactory.Candidate(2, "1ill Clinton", new uint8[](0)),
        //    ElectionFactory.Candidate(3, "Ross Perot", new uint8[](0))
        //];
        ElectionFactory.Election memory expectedElection = ElectionFactory.Election("USA president election", expectedCandidates, 0, true, 0, 0);

        assert(keccak256(abi.encodePacked(electionFactory._getElection(0).title)) == keccak256(abi.encodePacked(expectedElection.title)));
    }*/
}