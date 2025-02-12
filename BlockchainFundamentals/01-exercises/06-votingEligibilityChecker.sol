// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

contract voting{
    error TooYoungToVote();
    function eligibility(uint256 age) external pure returns (bool){
        if(age < 18){
            revert TooYoungToVote();
        }else{
            return true;
        }
    }
}