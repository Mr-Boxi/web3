// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// gas
// 发起交易你需要支付多少gas
//  gas spent * gas price
//
//  gas 是一个uint 计算单位
//  gas spent  是一笔交易 消耗gas 的总和
//  gas price  是你愿意为每个gas 支付多少ether

// gas price 越高，交易被打包进区块的优先级越高。
// 不支付gas 会被矿工拒绝打包的。


// gas limit
//
// gas limit 你愿意为交易支付的最高gas, 由你设置
// block gas limit  在一个区块中的最高gas, 由网络决定

contract Gas {
    uint public i = 0;

    // 消耗完gas 交易会失败
    function forever() public {
        // 这里是一个循环，知道消耗完gas
        while (true) {
            i += 1;
        }
    }
}