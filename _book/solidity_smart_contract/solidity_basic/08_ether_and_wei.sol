// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 交易需要支付 ether
// 1 ether = 10 ** 18 wei

contract EtherUints {
    uint public oneWei = 1 wei;
    // 1 wei is equal to 1
    bool public isOneWei = 1 wei == 1;

    uint public oneEther = 1 ether;
    // 1 ether is equal to 10 ** 18 wei
    bool public isOneether = 1 ether == 1e18;
}