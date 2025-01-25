// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;
    
contract compaundInterestCalculator{
    /*This task involves building a savings account contract that automates compound interest calculations. 
    The contract calculates the future balance of a principal amount after applying annual compounding interest 
    over a specified number of years. Each year, 
    interest is calculated based on the current balance and added for the next year’s calculation.*/
    
    uint256 public constant DECIMALS = 1e18;
    function calculateCompoundInterest(uint256 principal, uint256 interestRate, uint256 timeInYears) external pure returns (uint256) {
        uint256 interest = DECIMALS + (interestRate * DECIMALS / 100);
        uint256 compaund = principal;
        for(uint256 i = 0; i < timeInYears; i++){
            compaund = compaund * interest / DECIMALS;
        }
        return compaund;
}

}