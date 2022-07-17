# ethers js

docs: 

https://learnblockchain.cn/docs/ethers.js/

https://docs.ethers.io/v5/single-page/

- wallet

- providers

- contract

- utils

other doc:

https://cloud.tencent.com/developer/article/1520049
# etherjs 安装

```bash
# 在项目目录下安装 ethers.js
npm install --save ethers
```

# 导入ethers
```text
# es6
const ethers = require('ethers')

# ts
import {ethers} from 'ethers';
```

# why ethers
与Web3.js相比，Ethers.js有很多优点，其中我最喜欢的一个特性是Ethers.js提供的状态和密钥管理。Web3的设计场景是DApp应该连接到一个本地节点，由这个节点负责保存密钥、签名交易并与以太坊区块链交互。现实并不是这样的，绝大多数用户不会在本地运行一个geth节点。Metamask在浏览器 应用中有效地模拟了这种节点环境，因此绝大多数web3应用需要使用Metamask来保存密钥、签名交易并完成与以太坊的交互。

Ethers.js采取了不同的设计思路，它提供给开发者更多的灵活性。Ethers.js将“节点”拆分为两个不同的角色：

钱包：负责密钥保存和交易签名
提供器：负责以太坊网络的匿名连接、状态检查和交易发送