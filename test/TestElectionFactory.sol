// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.8.0;
pragma experimental ABIEncoderV2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/ElectionFactory.sol";

contract TestElectionFactory {
    ElectionFactory internal electionFactory;
    string[] namesList;
    string[] namesList2;

    function beforeEach() public {
        electionFactory = new ElectionFactory();
    }

    function test_get_election() public {

        namesList.push("George H. W. Bush");
        namesList.push("Bill Clinton");
        namesList.push("Ross Perot");

        namesList2.push("George H. W. Bush");
        namesList2.push("Bill Clinton");
        namesList2.push("Ross Perot");

        electionFactory._createElection("USA president election", namesList);
        electionFactory._createElection("Titi et gros minet", namesList2);

        //Assert.equal(string(electionFactory._getElection(1).getTitle()), string("Titi et gros minet"), "Should return the right election");
    }
}