// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/**
    委托调用
    delegatecall 是一个类似于 call 的低级函数。

    当合约A 对 合约B执行delegatecall时

    合约B的代码使用 合约的存储，  msg.sender and msg.value.
 */
 // NOTE: Deploy this contract first
contract B {
    // NOTE: storage layout must be the same as contract A
    uint public num;
    address public sender;
    uint public value;

    function setVars(uint _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract A {
    uint public num;
    address public sender;
    uint public value;

    function setVars(address _contract, uint _num) public payable {
        // A's storage is set, B is not modified.
        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }
}