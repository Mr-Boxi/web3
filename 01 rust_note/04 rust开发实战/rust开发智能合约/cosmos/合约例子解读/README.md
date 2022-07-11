### 合约例子解读

git仓库：https://github.com/InterWasm/cw-contracts.git

#### 入门合约

- escrow - A basic escrow with timeout and partial release
- erc20 - Basic implementation the erc20 interface for CosmWasm, as a base for token designers
- nameservice - Simple name service application to buy names and map values to those names
- voting - An example voting contract to create, manage, vote and deposit on polls
- simple-option - A contract that replicates options in finance
- cw20-pot - Basic smart contract using cw20 contact

#### 深入合约

...... 

### 智能合约库

- [cosmwasm-std](https://crates.io/crates/cosmwasm-std) ( [repo](https://github.com/CosmWasm/cosmwasm/tree/master/packages/std) )：用于构建 CosmWasm 智能合约的标准库。这个包中的代码被编译到智能合约中。
- [cosmwasm-storage](https://crates.io/crates/cosmwasm-storage) ( [repo](https://github.com/CosmWasm/cosmwasm/tree/master/packages/storage) )：帮助方法减少用于存储数据类型的库。更简单、更安全的持久层。
- [cosmwasm-schema](https://crates.io/crates/cosmwasm-schem) ( [repo](https://github.com/CosmWasm/cosmwasm/tree/master/packages/schema) )：CosmWasm 合约的开发依赖项，用于生成 JSON Schema 文件。

