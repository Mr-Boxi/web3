// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 常量
//  常量是硬编码的， 使用常量是可以节省gas。

contract Constants {
    // 常量名大写是编码约定
    address public constant MY_ADDRESS = 0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc;
    uint public constant MY_UINT = 123;
}