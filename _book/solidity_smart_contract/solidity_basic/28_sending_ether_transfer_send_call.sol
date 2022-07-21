// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


/**

如何发送ether
    
    发送以太给其他合约可以通过：
        - transfer (2300 gas, throw error)
        - send(2300gas, returns bool)
        - call(forward all gas or set gas, returns bool)


如何接受ether

    接收 Ether 的合约必须至少具有以下函数之一
        - receive() external payable
        - fallback() external payable

        receive() is called if msg.data is empty, otherwise fallback() is called.

应该选用那个方法

    `call`  2019 年 12 月以后推荐使用 call 和 重入防范相结合的方法。

    重入防范相结合的方法
        - 在调用其他合约之前进行所有状态更改
        - 使用重入保护修饰符
 */

 contract ReceiveEther {
    /*
    Which function is called, fallback() or receive()?

           send Ether
               |
         msg.data is empty?
              / \
            yes  no
            /     \
receive() exists?  fallback()
         /   \
        yes   no
        /      \
    receive()   fallback()
    */


    // 接受以太的函数， msg.data 必须要是空的
    receive() external payable {}

    // msg.data  不是空的时候
    fallback() external payable {}


    function getBalance() public view returns (uint){
        return address(this).balance;
    }
}

contract SendEther{
    function sendViaTransfer(address payable _to) public payable {
        // This function is no longer recommended for sending Ether.
        // 不推荐
        _to.transfer(msg.value);
    }

    function sendViaSend(address payable _to) public payable {
        // Send returns a boolean value indicating success or failure.
        // This function is not recommended for sending Ether.
        // 不推荐
        bool sent = _to.send(msg.value);
        require(sent, "Failed to send Ether");
    }

    function sendViaCall(address payable _to) public payable {
        // Call returns a boolean value indicating success or failure.
        // This is the current recommended method to use.
        // 这个是目前推荐的方法
        (bool sent, bytes memory data) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }    
}