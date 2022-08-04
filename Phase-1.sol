// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Transactions is ERC721URIStorage{
    
    uint256 transactionCount;
    uint256  public constant STAKE = 10; 
    address private immutable owner;
    //Initializiing CourseStakes to corresponding Course ID's
    uint[] CourseStakes = [12,15,19,40,20,40,76,14,64,27];
    // Real Value = CourseStake/100
    

    event Transfer(address from, address reciever, uint amount, string message, uint256 timestamp);
    event Enrollment(address from, address reciever, uint amount, uint256 timestamp);
    struct CertificateTransferStruct {
        address sender;
        address reciever;
        uint amount;
        string URILink;
        uint256 timestamp;
    }
    struct EnrollmentStruct {
        address sender;
        address reciever;
        uint amount;
        uint256 timestamp;
    }

    CertificateTransferStruct[] transactions;
    EnrollmentStruct[] enrollment;
    constructor() ERC721("Transactions","RIN") {
        owner = msg.sender;
    }

    function CertficateTransaction(address payable reciever, string memory URILink,uint256 CourseID) public {
        transactionCount += 1;
        require(msg.sender == owner, "Invalid Transaction");
        transactions.push(CertificateTransferStruct(msg.sender, reciever, CourseStakes[CourseID], URILink, block.timestamp));
        (bool CallSuccess,) = payable(reciever).call{value: (CourseStakes[CourseID])/100}("");
        require(CallSuccess,"Transaction Failed");
        emit Transfer(msg.sender, reciever, CourseStakes[CourseID], URILink, block.timestamp);
    }
    function CourseEnrollment(uint CourseID) public{
        require(msg.sender != owner, "Invalid Transaction");
        enrollment.push(EnrollmentStruct(msg.sender, owner, CourseStakes[CourseID], block.timestamp));
        (bool CallSuccess,) = payable(owner).call{value: (CourseStakes[CourseID])/100}("");
        require(CallSuccess,"Transaction Failed");
        emit Enrollment(msg.sender, owner, CourseStakes[CourseID],block.timestamp);

    }

    // function getAllTransactions() public view returns (TransferStruct[] memory) {
    //     return transactions;
    // }

    // function getTransactionCount() public view returns (uint256) {
    //     return transactionCount;
    // }
}
