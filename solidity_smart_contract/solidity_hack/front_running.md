# front running

交易在被打包之前需要一些时间。攻击者可以监视tx池并发送tx，在原始tx之前将其包含在块中。这种机制可以被滥用来为攻击者重新排序tx.

```solidity

/*
如果您能找到散列到目标的正确字符串，您将赢得 10 个以太币 哈希。让我们看看这个合约如何容易受到抢先交易的影响。

1. Alice 使用 10 个 Ether 部署 FindThisHash.
2. Bob 找到将散列到目标散列的正确字符串。 （“以太坊”）
3. Bob 调用solve("Ethereum")，gas 价格设置为15 gwei。
4. Eve 正在观察交易池等待提交的答案。
5. Eve 看到 Bob 的回答并以更高的 gas 价格调用 solve("Ethereum") 比鲍勃（100 gwei）。
6. Eve 的交易在 Bob 的交易之前被挖掘。 Eve 获得了 10 个以太币的奖励。


交易需要一些时间才能被挖掘。
交易需要一些时间才能被挖掘。
天然气价格较高的交易通常首先被开采。
攻击者可以从交易池中得到答案，发送交易 具有更高的汽油价格，以便他们的交易将包含在一个区块中 在原版之前。
*/
contract FindThisHash {
    bytes32 public constant hash =
        0x564ccaf7594d66b1eaaea24fe01f0585bf52ee70852af4eac0cc4b04711cd0e2;

    constructor() payable {}

    function solve(string memory solution) public {
        require(hash == keccak256(abi.encodePacked(solution)), "Incorrect answer");

        (bool sent, ) = msg.sender.call{value: 10 ether}("");
        require(sent, "Failed to send Ether");
    }
}
```



### 预防技术

- use commit-reveal scheme
- use submarine send