// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.8.0;
pragma experimental ABIEncoderV2;

import "truffle/Assert.sol";

import "../contracts/ElectionFactory.sol";

contract TestElectionFactory {
    ElectionFactory voteContract;
    string[] namesList;
    string[] namesList2;

    function beforeEach() public {
        delete namesList;
        namesList.push("George H. W. Bush");
        namesList.push("Bill Clinton");
        namesList.push("Ross Perot");

        voteContract = new ElectionFactory();
    }

    function generateSecondNameList() public {
        delete namesList2;
        namesList2.push("Titi");
        namesList2.push("Gros");
        namesList2.push("Minet");
    }

    function test_election_creation() public {
        uint electionId = voteContract.createElection("USA president election", namesList);

        Assert.equal(string(voteContract.getElectionTitle(electionId)), string("USA president election"), "Title of the first election should be USA president election");
        Assert.equal(string(voteContract.getCandidateName(electionId, 0)), string(namesList[0]), "First candidate sould be George H. W. Bush");
        Assert.equal(string(voteContract.getCandidateName(electionId, 1)), string(namesList[1]), "Second candidate sould be Bill Clinton");
        Assert.equal(string(voteContract.getCandidateName(electionId, 2)), string(namesList[2]), "Third candidate sould be Ross Perot");
    }

    function testAddCandidate() public {
        uint electionId = voteContract.createElection("USA president election", namesList);

        voteContract.addCandidate(electionId, "Candidat Test");
        Assert.equal(string(voteContract.getCandidateName(electionId, 3)), string("Candidat Test"), "Candidate should be added to the list");
    }

    function test_candidates_names() public {
        generateSecondNameList();

        uint firstElectionId = voteContract.createElection("USA president election", namesList);
        uint secondElectionId = voteContract.createElection("Titi et gros minet", namesList2);

        Assert.equal(string(voteContract.getElectionTitle(secondElectionId)), string("Titi et gros minet"), "Should return the right election");
        Assert.equal(string(voteContract.getCandidateName(secondElectionId, 0)), string("Titi"), "Should return the right candidate name");
        Assert.equal(string(voteContract.getCandidateName(firstElectionId, 0)), string("George H. W. Bush"), "Should return the right candidate name");
    }

    // Outdated test
    /*function test_get_elections() public {
        namesList.push("George H. W. Bush");
        namesList.push("Bill Clinton");
        namesList.push("Ross Perot");

        namesList2.push("Titi");
        namesList2.push("Gros");
        namesList2.push("Minet");

        uint firstElectionId = this._createElection("USA president election", namesList);
        uint secondElectionId = this._createElection("Titi et gros minet", namesList2);

        Assert.equal(int(electionFactory._getElections().length), int(2), "Should return the right election");

    }*/
}