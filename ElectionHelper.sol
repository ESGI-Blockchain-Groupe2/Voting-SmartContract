pragma solidity ^0.4.0;
import "./ElectionFactory.sol";

contract ElectionHelper /*is ElectionVoting ou VoteCreation*/ {
    function ElectionHelper() {}

    function changeTitle(uint _electionId, string calldata _newTitle) external /*onlyAdmin*/ {
        elections[_electionId].title = _newTitle;
    }

    function changeChoiceTitle(uint _electionId, uint _choiceId, string calldata _newTitle) external /*onlyAdmin*/ {
        elections[_electionId].choices[] = _newTitle;
    }
}
