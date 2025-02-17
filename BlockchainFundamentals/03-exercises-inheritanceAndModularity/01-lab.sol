// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PaymentProcessor  { //Parent contract
    address public owner;
    mapping(address => mapping(uint256 => Client)) public clientTransactions;
    
    struct Client {
        address clientAddress;
        uint256 dateOfDeposit;
        uint256 transactionID;
        uint256 depositAmount;
        
    }
    mapping (address => uint256) public totalBalance;
    constructor() {
        owner = msg.sender;
    }
    function registerClient(address _clientAddress) public {
    require(msg.sender == owner,"Only the owner can register a new client");
        
        clientTransactions[_clientAddress][0] = Client(_clientAddress, block.timestamp, 0, 0);

        
    }
    uint256 public currentTransactionID;
    function depositFunds () public payable {
        require(msg.value > 0,"No funds deposited");
        
        uint256 transactionID = currentTransactionID;
        
        
        
        clientTransactions[msg.sender][transactionID] = Client (
            msg.sender,
            block.timestamp,
            currentTransactionID,
            msg.value
        );
        totalBalance[msg.sender] += msg.value;
        currentTransactionID++;
    }
    
    function getBalance(address _fundsOwner) public view returns (uint256){
       return  totalBalance[_fundsOwner];
    }
    function getTransactionID(address _fundsOwner, uint256 _trasactionID) public view returns (uint256){
        uint256 transactioID = clientTransactions[_fundsOwner][_trasactionID].transactionID;
        return  transactioID;
    }
    
     function refundPayment (address _fundsOwner, uint256 _trasactionID) public payable virtual  returns (uint256){
        require(msg.sender == owner,"Only the owner can refund payment");
        require(_trasactionID == clientTransactions[_fundsOwner][_trasactionID].transactionID, "Invalid transaction id");
        require(totalBalance[_fundsOwner] > clientTransactions[_fundsOwner][_trasactionID].depositAmount, "Insufficient amount in balance");
        uint256 exactTransaction = clientTransactions[_fundsOwner][_trasactionID].depositAmount;
        totalBalance[_fundsOwner] -= exactTransaction;
        (bool succses, ) = _fundsOwner.call{value: exactTransaction}("");
        require(succses, "Refund failed");
        
        return exactTransaction;
    }


}
contract Merchant is PaymentProcessor { // Child contract
    constructor () PaymentProcessor() {}

    function refundPayment (address _fundsOwner, uint256 _trasactionID) public payable override  returns (uint256){
        uint256 refundableTime = clientTransactions[_fundsOwner][_trasactionID].dateOfDeposit + 14 days; // 14 days refund period
        require(block.timestamp < refundableTime, "14 days introduced for refund has expired");
        uint256 clientDeposit = clientTransactions[_fundsOwner][_trasactionID].depositAmount;
        uint256 loyalClientBonus;
        loyalClientBonus = (clientDeposit * 1) / 100; // 1% Bonus
        if(totalBalance[_fundsOwner] >= 10 ether){
           clientTransactions[_fundsOwner][_trasactionID].depositAmount += loyalClientBonus;
        }
        super.refundPayment(_fundsOwner, _trasactionID);
        return clientTransactions[_fundsOwner][_trasactionID].depositAmount;

    }
}