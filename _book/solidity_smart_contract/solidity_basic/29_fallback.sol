// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


/**
    fallback 是一个不接受任何参数且不返回任何内容的函数。

    它在什么时候执行
        -  调用不存在的函数
        -  发送ether 给合约的时候，合约没有 receive(), or msg.data 是空的时候

 */

 contract Fallback {
    event Log(uint gas);

    // Fallback function must be declared as external.
    fallback() external payable {
        // send / transfer (forwards 2300 gas to this fallback function)
        // call (forwards all of the gas)
        emit Log(gasleft());
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract SendToFallback {
    function transferToFallback(address payable _to) public payable {
        _to.transfer(msg.value);
    }

    function callFallback(address payable _to) public payable {
        (bool sent, ) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}