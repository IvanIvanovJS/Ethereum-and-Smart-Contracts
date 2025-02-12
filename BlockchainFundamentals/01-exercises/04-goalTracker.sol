// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;
/*The Goal Tracker contract allows a user to track their spending toward a goal. 
Once a user’s total spending meets or exceeds this goal, they can claim a reward.
Claim Reward: Allows the user to claim the reward if their spending meets or exceeds the goal amount. 
The reward is compounded using a for loop and can only be claimed once.
*/
    contract goalTracker{
        uint256 public goalSet;
        uint256 public baseReward;
        uint256 public totalReward;
        uint256 public alreadySpent;
        bool public isRewardClaimed;
        constructor (uint256 _goalSet, uint256 _baseReward){
            goalSet = _goalSet;
            baseReward = _baseReward;
        }
        
        error AlreadyClaimed();
        function goalTracking(uint256 spending) external    {
            if(isRewardClaimed){
                revert AlreadyClaimed();
            }
            alreadySpent += spending;
            if(alreadySpent >= goalSet){
                totalReward += goalSet;
                for(uint256 i = 1; i <= 5; i++){
                    totalReward += baseReward;
                }
                isRewardClaimed = true;
                
            }
            
        }
    }