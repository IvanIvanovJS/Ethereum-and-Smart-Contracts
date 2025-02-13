// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

contract voting {
    struct Voter {
        bool hasVoted;
        uint256 choice;
    }
    mapping (address => Voter) public voterDitails;
    struct candidate{
        uint256 candidateID;
    }
    
    function registerVote(uint256 candidateID) external {
        require(voterDitails[msg.sender].hasVoted == false, "Already");
        voterDitails[msg.sender] = Voter(true, candidateID);
        
    }
    function getVoterStatus(address voterAdress) external view  returns (bool, uint256){
        return (voterDitails[voterAdress].hasVoted, 
                voterDitails[voterAdress].choice);

}
}