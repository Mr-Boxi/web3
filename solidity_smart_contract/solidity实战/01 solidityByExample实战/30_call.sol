// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


/**
    call 是与其他合约交互的低级函数。

    当您只是通过调用回退函数发送以太币时，这是推荐的方法。

    但是，这不是调用 已存在函数 的推荐方法。
 */

 contract Receiver {
     
     event Received(address caller, uint amount, string message);
     fallback() external payable{
         emit Received(msg.sender, msg.value, "fallback was called");
     }

    function foo(string memory _message, uint _x) public payable returns (uint) {
        emit Received(msg.sender, msg.value, _message);

        return _x + 1;
    }     
 }


 contract Caller {
     event Response(bool success, bytes data);


    // 我们可以想象一下， 合约B 是没有 合约A 的代码的。
    // 但是我们知道合约A 的地址 和 函数
    function testCallFoo(address payable _addr) public payable {
        (bool success, bytes memory data) = _addr.call{value: msg.value, gas: 5000}(
            abi.encodeWithSignature("foo(string, uint256)", "call foo", 123)
        );
        emit Response(success, data);
    }


    // 调用不存在的函数会触发 fallback 调用
    function testCallDoesNotExist(address _addr) public {
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("doesNotExist()")
        );

        emit Response(success, data);
    }
 }