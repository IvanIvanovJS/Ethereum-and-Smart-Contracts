// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

contract loanCalculator {
    error interestRateOutOfBoundries(string);
    error loanPeriodTooShort(string);
    function calculateTotalPayable (uint256 principal, uint256 rate, uint256 loanYears) external pure returns (uint256){
        if(rate < 0 || rate > 100){
            revert interestRateOutOfBoundries("Must be between 0 - 100");
        }else if (loanYears < 1){
            revert loanPeriodTooShort("Must be atleast 1 year");
        }else {
            uint256 total = principal + (principal * rate * loanYears / 100);
            return  total;
        }
        

    }
}