pragma solidity ^0.4.0;

// 简单的拍卖
contract SimpleAuction {

    address public beneficiary;
    uint public auctionEnd;

    address public highestBidder;
    uint public highestBid;

    mapping(address => uint) pendingReturnes;

}
