// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;
    /*This task involves building a contract that calculates how a total expense should be split among a group of people, 
    ensuring each person contributes an equal share. 
    The contract verifies that the total amount can be evenly divided among the participants, 
    providing a custom error if it cannot be split evenly.*/
contract billSplitter{
    
    uint256 public splitExpenses;
    error UnevenDivision();
    error ZeroParticipants();
    function billing (uint256 totalExpenses, uint256 numberOfPeople) external{
       if (numberOfPeople == 0) {
            revert ZeroParticipants();
        }
        splitExpenses = totalExpenses / numberOfPeople;
        if(totalExpenses % numberOfPeople != 0){
            revert UnevenDivision();
        }
    }
}