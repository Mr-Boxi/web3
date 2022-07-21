pragma solidity ^0.8.13;

// 英式拍卖
// Auction
//      seller 部署合约
//      拍卖持续7天
//      参与者可以通过存入高于当前最高出价者的 ETH 来出价。
//      如果不是当前的最高出价，所有投标人都可以撤回他们的出价
// after the auction
//      Highest bidder becomes the new owner of NFT
//      The seller receives the highest bid of ETH


interface IERC721 {
    function safeTransferFrom(address from, address to, uint tokenid)external;
    function transferFrom(address, address, uint) external;
}
contract EnglishAuction {
    event Start();
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);
    event End(address winner, uint amount);

    IERC721 public nft;
    uint nftId;

    address payable public seller;
    uint public endAt;
    bool public started;
    bool public ended;

    address public highestBidder;
    uint public highestBid;
    mapping(address => uint) public bids;

    constructor(
        address _nft,
        uint _nftId,
        uint _startingBid
    ){
        nft = IERC721(_nft);
        nftId = _nftId;

        seller = payable(msg.sender);
        highestBid = _startingBid;
    }

    function start() external {
        require(!started, "started");
        require(msg.sender == seller, "not seller");

        nft.transferFrom(msg.sender, address(this), nftId);
        started = true;
        endAt = block.timestamp + 7 days;

        emit Start();
    }

    function bid() external payable {
        require(started, "not start");
        require(block.timestamp < endAt, "ended");
        rquire(msg.value > highestBid, "value < highest");

        hightestBidder = msg.sender;
        highestBid = msg.vlue;

        emit Bid(msg.sender, msg.value);
    }

    function withdraw() external {
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(bal);

        emit Withdraw(msg.sender, bal);
    }

    function end() external {
        require("stared", "not started");
        require(block.timestamp >= endAt, "not end");
        require(!ended, "ended");

        ended = true;
        if (highestBidder != address(0)){
            nft.safeTransferFrom(address(this), highestBidder, nftId);
            seller.transfer(highestBid);
        }else {
            nft.safeTransferFrom(address(this), seller, nftId);
        }
        emit End(highestBidder, highestBid);
    }
}
