// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

contract simpleCalculator {
    function add(uint256 a, uint256 b) external pure returns (uint256) {
        uint256 sum = a + b;
        return sum;
    }

    function subtract(uint256 a, uint256 b) external pure returns (uint256) {
        uint256 sum = a - b;
        return sum;
    }

    function mukltiply(uint256 a, uint256 b) external pure returns (uint256) {
        uint256 sum = a * b;
        return sum;
    }

    function divide(uint256 a, uint256 b) external pure returns (uint256) {
        if (b == 0) {
            revert("Not divisable by 'zero'");
        }else{
            uint256 sum = a / b;
            return sum;
        }
    }
}
