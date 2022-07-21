// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/**
    Ether wallet
    
    一个以太坊钱包实例
        -  任何人都可以发送 eth
        -  只有owner 可以 withdraw
*/

contract EtherWallet {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }


    receive() external payable {}


    function withdraw(uint _amount) external {
        require(msg.sender == owner, "caller is not owner");
        payable(msg.sender).transfer(_amount);
    }

    function getBalance() external view returns (uint){
        return address(this).balance;
    }
}