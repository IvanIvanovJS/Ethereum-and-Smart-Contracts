// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;
    
contract compaundInterestCalculator{
    
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