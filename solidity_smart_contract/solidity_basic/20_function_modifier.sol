// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


//  modifier  函数修饰符
//
// 一般用作：
// 
//   - 限制访问
//   - 输入校验
//   - 防范重入攻击

contract FunctionModifier {
    address public owner;
    uint public x = 10;
    bool public locked;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        // 满足条件按，执行剩下的代码
        _ ;
    }

    modifier validAddress(address _addr) {
        require(_addr != address(0), "not valid address");
        _;
    }

      function changeOwner(address _newOwner) public onlyOwner validAddress(_newOwner) {
        owner = _newOwner;
    }


    // 防止重入
    // 在函数执行期间，防止再次进入
    modifier noReentrancy() {
        require(!locked, "no reentrancy");
        locked = true;
        _;
        locked = false;
    }

    function decrement(uint i) public noReentrancy{
        x -= i;
        if (i > 1) {
            decrement(i -1);
        }
    }

}