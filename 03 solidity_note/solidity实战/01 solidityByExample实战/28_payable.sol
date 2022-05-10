// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


/**
    函数 或者 地址 定义为payabel 则合约就可以接受 ether
 */

 contract Payable {
     // payable address can receive ether
     address payable public owner;

     // payable constructor can receive ether
     constructor() payable{
         owner = payable(msg.sender);
     }


     // 函数会将 ether 存入 合约中
     // 使用ether 调用这个函数
     // 合约的余额可以自动的更新
     function deposit() public payable{}

    // 使用ether 去调用这个函数会抛出错误
    // 因为这个函数没有payable 
    function notPayable() public {}


    // 从这个合约中提取所有 ether
    function withdraw() public {
        // 获取总额
        uint amount = address(this).balance;

        // 将所有余额发给合约拥有者
        // 合约拥有者可以获取余额， 因为这个地址是payable
        (bool success, ) = owner.call{value: amount}("");
        require(success, "Failed to send ether");
    }


    // 从这合约 给 输入的地址 转钱
    function transfer(address payable _to, uint _amount) public{
        // _to 需要被定义为 payable
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "Failed to send ether");
    }
 }