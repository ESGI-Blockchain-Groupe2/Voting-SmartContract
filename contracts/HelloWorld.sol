// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.8.0;

contract HelloWorld {
    string private greeting;

    constructor() {
        greeting = "Hello World";
    }

    function getGreeting() public view returns(string memory){
        return greeting;
    }
}