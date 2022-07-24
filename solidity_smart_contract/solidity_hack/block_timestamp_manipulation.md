# 操作区块时间戳

可以由具有以下约束的矿工操纵

- it cannot be stamped with an earlier time than its parent
- it cannot be too far in the future

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/*
轮盘赌是一种游戏，您可以在其中赢得合同中的所有以太币
如果您可以在特定时间提交交易。
如果 block.timestamp % 15 == 0，玩家需要发送 10 个 Ether 并获胜。
*/

/*
1. 使用 10 Ether 部署轮盘赌
2. Eve 运行一个强大的矿工，可以操纵区块时间戳。
3. Eve 将 block.timestamp 设置为将来可被整除的数字 15 并找到目标块哈希。
4. Eve 的区块成功入链，Eve 赢得 轮盘赌游戏。
*/

contract Roulette {
	uint public pastBlockTime;
	
	constructor() payable{}
	
	function spin() external payable {
		require(msg.value == 10 ether);
		require(block.timestamp != pastBlockTime);
		
		pastBlockTime = block.timestamp;
		
		if(block.timestamp % 15 == 0) {
			(bool sent, ) = msg.sender.call{value: address(this).balance}("");
			require(sent, "failed to send ether");
		}
	}
}
```

### 预防技巧

不要使用 block.timestamp 作为熵和随机数的来源
