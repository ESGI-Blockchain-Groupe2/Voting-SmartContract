pragma solidity ^0.7.0;
import "./ElectionFactory.sol";

contract ElectionHelper is ElectionFactory {
    constructor() {}

    function changeTitle(uint _electionId, string calldata _newTitle) external /*onlyAdmin*/ {
        elections[_electionId].title = _newTitle;
    }

    function changeChoiceTitle(uint _electionId, uint _choiceId, string calldata _newTitle) external /*onlyAdmin*/ {
        elections[_electionId].choices[] = _newTitle;
    }
}
