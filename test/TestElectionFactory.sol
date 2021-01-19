// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.8.0;
pragma experimental ABIEncoderV2;

import "truffle/Assert.sol";

import "../contracts/ElectionFactory.sol";

contract TestElectionFactory {


    ElectionFactory internal electionFactory;
    string[] namesList;
    string[] namesList2;

    function beforeEach() public {
        electionFactory = new ElectionFactory();
    }


    function test_election_creation() public {

        delete namesList;
        namesList.push("George H. W. Bush");
        namesList.push("Bill Clinton");
        namesList.push("Ross Perot");

        electionFactory._createElection("USA president election", namesList);

        Election[] memory electionList = electionFactory._getElections();

        Assert.equal(string(electionList[0].getTitle()), string("USA president election"), "Title of the first election should be USA president election");
        Assert.equal(string(elections[0].candidates[0].name), string(namesList[0]), "First candidate sould be George H. W. Bush");
        Assert.equal(string(elections[0].candidates[1].name), string(namesList[1]), "Second candidate sould be Bill Clinton");
        Assert.equal(string(elections[0].candidates[2].name), string(namesList[2]), "Third candidate sould be Ross Perot");
    }

    function test_end_election() public {
        delete namesList;
        namesList.push("George H. W. Bush");
        namesList.push("Bill Clinton");
        namesList.push("Ross Perot");

        electionFactory._createElection("USA president election", namesList);

        electionFactory._endElection(0);

        Assert.equal(electionFactory._getElection(0).getStatus(), false, "test");

    }

    function test_get_election() public {

        delete namesList;
        delete namesList2;

        namesList.push("George H. W. Bush");
        namesList.push("Bill Clinton");
        namesList.push("Ross Perot");

        namesList2.push("Titi");
        namesList2.push("Gros");
        namesList2.push("Minet");

        electionFactory._createElection("USA president election", namesList);
        electionFactory._createElection("Titi et gros minet", namesList2);

        Assert.equal(string(elections[1].name), string("Titi et gros minet"), "Should return the right election");
        Assert.equal(string(elections[1].candidates[0].name), string("Titi"), "Should return the right candidate name");
        Assert.equal(string(elections[0].candidates[0].name), string("George H. W. Bush"), "Should return the right candidate name");
    }

    function test_get_elections() public {

        delete namesList;
        delete namesList2;


        namesList.push("George H. W. Bush");
        namesList.push("Bill Clinton");
        namesList.push("Ross Perot");


        namesList2.push("Titi");
        namesList2.push("Gros");
        namesList2.push("Minet");


        electionFactory._createElection("USA president election", namesList);
        electionFactory._createElection("Titi et gros minet", namesList2);


        Assert.equal(int(electionFactory._getElections().length), int(2), "Should return the right election");

    }
}