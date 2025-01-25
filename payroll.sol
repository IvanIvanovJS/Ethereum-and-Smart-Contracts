// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

contract payroll{
    uint256 public result;

    /*This task involves building a payroll contract that calculates an employee’s paycheck based on their base salary and performance rating. 
    If the employee’s performance exceeds a specific threshold, they receive a bonus. 
    This contract ensures accurate paycheck calculations, factoring in performance-based bonuses.*/
    function calclulatePayroll (uint256 salary, uint256 performanceRating) external {
        if(salary == 0 || performanceRating > 10){
            revert("Invalid input");
        } else if(performanceRating >= 8){
            salary = (salary * 11) / 10; //add 10% bonus
            result = salary;
        }else {
            result = salary; //no bonus
        }

        
        
    }
}
