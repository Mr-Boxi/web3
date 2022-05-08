# cosmos-sdk

开发教程：
https://tutorials.cosmos.network/

https://docs.cosmos.network/

多阅读：sdk 文档

有方法有步骤，就是慢慢来，一点一点阅读完文档，按照文档练习就可以。
看文档估计需要一周，练习需要一周。

// all in one solution
https://docs.starport.com/

// 练习：
https://tutorials.cosmos.network/academy/4-my-own-chain/starport.html

# cosmos-sdk tools
在链中启用合约
- Agoric Swingset  [js]
- CosmWasm         [rust]
- Ethermint        [solidity]


## cosmwasm
文档：https://docs.cosmwasm.com/docs/1.0/

```
 |  sdk   | ---- |    dll/so | --- |    vm     |
 | x/wasm | --- |wasmvm[cgo]| --- |cosmwasm[vm]|

```

## ethermint
文档：https://docs.ethermint.zone/

## evmos
文档： https://evmos.dev/intro/overview.html


## 设想

secret network 是改写了cosmwasmvm--> sgx-vm
ehermint 将 evm 做成模块放入cosmos-sdk

将evm 放入 sgx-vm 中运行是否可以？