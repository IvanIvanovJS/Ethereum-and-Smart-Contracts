// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

contract messageBoard {

    mapping(address => string[]) public messages;

    function storedMessages(string memory messageInput) external{
        messages[msg.sender].push(messageInput);
    }

    function messagePrewiew (string calldata messageToPreview) external pure returns (string memory){
        return  string(abi.encodePacked("Draft:", messageToPreview));

    }
}