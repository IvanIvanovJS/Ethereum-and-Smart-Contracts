// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

contract savingAccount {
    struct SavingsAccount {
        uint256 balance;
        address owner;
        uint256 creationTime;
        uint256 lockPeriod;
    }
    mapping (address => SavingsAccount[]) public database;
    function createAcount (uint256 addedBalance, uint256 lockPeriod) external payable  {
        
        database[msg.sender].push(SavingsAccount({
            balance: addedBalance,
            owner: msg.sender,
            creationTime: block.timestamp,
            lockPeriod: lockPeriod
        }));
        

    }
    function viewSavingPlan (address user, uint256 index) external view returns(uint256,address,uint256,uint256){
        return((database[user])[index].balance,(database[user])[index].owner,(database[user])[index].creationTime,(database[user])[index].lockPeriod);
    }  
    function withdraw (uint256 amount,address user, uint256 index) external{
        require(block.timestamp >=((database[msg.sender])[0].creationTime+ database[msg.sender][0].lockPeriod),"You are not eligible to Withdraw"); 

        if ((database[user])[index].balance < amount){
            revert("Balance is insufficient") ;
        } else{
             (database[user])[index].balance -=amount;
         }   
         
   }
    function newDeposit (uint256 additionalDeposit, uint256 index) external {
        require(index < database[msg.sender].length, "Deposit not found");
        database[msg.sender][index].balance += additionalDeposit;

    } 

}