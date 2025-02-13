// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;
    
    contract Crowdfunding {
        uint256 public goalAmount;
        uint256 public startTime;
        uint256 public endTime;
        bool public isGoalAchieved;
        uint256 public proggressAmount;
        mapping (address => Backer) contributionsDetail;
        struct Backer {
            address fromAddress;
            uint256 amountContributed;

        }
        Backer[] public contributors;
        
        error GoalAlreadyAchieved();
    constructor (uint256 _goalAmount){
        startTime = block.timestamp;
        goalAmount = _goalAmount;
        endTime = block.timestamp + 10 seconds;
    }

    function contribute (uint256 contributionAmount) external {
        if(isGoalAchieved == true){
            revert GoalAlreadyAchieved();
        }
        
        require(block.timestamp < endTime && block.timestamp > startTime, "Out of time");
        
        
        contributors.push(Backer(msg.sender, contributionAmount));
        proggressAmount += contributionAmount;
        if(proggressAmount >= goalAmount){
            isGoalAchieved = true;
            
            
        }
       

    }
    function withdraw () external returns (address, uint256){
        if(block.timestamp > endTime && isGoalAchieved == false){
            
            proggressAmount = 0;
            contributionsDetail[msg.sender] = Backer(msg.sender, 0);
            return (contributionsDetail[msg.sender].fromAddress,
                   contributionsDetail[msg.sender].amountContributed);
        }
    }
}