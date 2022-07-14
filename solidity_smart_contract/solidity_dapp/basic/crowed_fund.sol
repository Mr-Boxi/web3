// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


// 众筹
// 用户创建活动。

// 用户可以承诺，转移他们的标志到一个运动。

// 在活动结束后，如果承诺的总金额超过活动目标，活动创作者可以要求资金。

// 否则，活动没有达到它的目的，用户可以撤回他们的承诺

interface IERC20 {
    function transfer(address, uint) external returns(bool);

    function transferFrom(address ,address, uint) external returns (bool);
}

contract CrowdFund {
    event Launch(uint id, address indexed creator, uint goal, uint32 startAt, uint32 endAt);
}