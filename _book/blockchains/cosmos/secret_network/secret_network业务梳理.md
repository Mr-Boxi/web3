# secretd_network 业务梳理

这条链可以做什么？ 查看tx有什么命令基本就可以确定可以做什么。

## 创世文件 genesis.json

```json
{
  "genesis_time": "2022-05-12T04:35:14.397130098Z",
  "chain_id": "secretdev-1",
  "initial_height": "1",
  "consensus_params": {
    "block": {
      "max_bytes": "22020096",
      "max_gas": "-1",
      "time_iota_ms": "1000"
    },
    "evidence": {
      "max_age_num_blocks": "100000",
      "max_age_duration": "172800000000000",
      "max_bytes": "1048576"
    },
    "validator": {
      "pub_key_types": [
        "ed25519"
      ]
    },
    "version": {}
  },
  "app_hash":"",
  "app_state":{...各个模块的初始参数}
}
```

### 共识参数

consensus_params 

- block字段  设置区块最大值，

- evidence字段 

- 验证器字段

### 各模块的初始参数

所使用到的模块如下

```
auth, authz, bank, capability, compute, crisis, distribution, evidence, feegrant, genutil, gov, ibc,  icamsgauth, interchainaccounts, mint, params, register, shashing, transfer, 
upgrade, vesting
```

### auth 模块

帐户和交易的身份验证

可以做什么？做交易

### authz 模块

将任意权限从一个账户授予(授予者)给另一个账户(被授予者)。

1. 通用授权

`GenericAuthorization`实现`Authorization`接口，该接口授予代表授予者帐户执行提供的 Msg 的不受限制的权限。相当于完全授权

2. 发送授权

`SendAuthorization`实现Msg的`Authorization`接口。`cosmos.bank.v1beta1.MsgSend`它需要一个（正数）`SpendLimit`来指定受让人可以花费的最大代币数量。

3. 权益授权

`StakeAuthorization`实现[质押模块](https://docs.cosmos.network/v0.44/modules/staking/)`Authorization`中的消息接口. 需要`AuthorizationType`指定您是否要授权委托、取消委托或重新委托（即这些必须单独授权）。它还需要`MaxTokens`跟踪可以委托/取消委托/重新委托的令牌数量的限制。如果留空，则金额不受限制。

#### Clinet使用

#### Query 

...

#### Transactions

查看authz模块使用

```bash
secretd tx authz --help
```

##### exec

Exec 命令允许被授权人代表授权人执行事务

```bash
secretd tx authz exec [tx-json-file] --from [grantee] [flags]
```

```bash
secretd tx authz exec tx.json --from=cosmos1..
```

##### grant

Grant命令允许授权者给一个账号授权

```bash
secretd tx authz grant <grantee> <authorization_type="send | generic | delegate | unbond redelegate"> --from <granter> [flags]

# example 
secretd tx authz grant cosmos1.. send --spend-limit=100stake --from=cosmos1..
```

##### revoke

revoke 撤销授权

```bash
secretd tx authz revoke [grantee] [msg-type-url] --from=[granter] [flags]

# example
secretd tx authz revoke cosmos1.. /cosmos.bank.v1beta1.MsgSend --from=cosmos1..
```



### bank 模块

处理账户之间多资产代币转账，bank模块跟踪应用程序中使用的所有资产的总供应量并提供查询支持。

#### Query

查询代币总供应量

```
secretd query bank total
```

#### Transactions

##### send

send 命令允许用户发送资金到另一个用户。

```bash
secretd tx bank send [from_key_or_address] [to_address] [amount] [flags]
```



### capability 模块

 对象能力实现。

`x/capability`是根据[ADR 003](https://docs.cosmos.network/main/docs/architecture/adr-003-dynamic-capability-store.html)的Cosmos SDK 模块的实现，它允许在运行时配置、跟踪和验证多所有者功能。



### crisis 模块

在区块链不变量被破坏的情况下停止区块链。可以在应用程序初始化过程中向应用程序注册不变量。



在不变量被破环的时候提交证明

```bash
secretd tx crisis invariant-broken [module-name] [invariant-route] [flags]

# example  例如 bank 的总供应量被破坏
secretd tx crisis invariant-broken bank total-supply --from=[keyname or address]

# 检查不变量，如果不变量被破坏，停止区块链。
```

### distribution 模块

 费用分配和 Staking 代币供应分配。验证者和委托人之间被动分配奖励的功能性方式

### mint 模块

- 允许灵活的通货膨胀率由针对特定债券比率的市场需求决定
- 实现市场流动性和质押供应之间的平衡

铸币参数保存在全局存储中。

| Key                 | Type            | Example                |
| :------------------ | :-------------- | :--------------------- |
| MintDenom           | string          | "uatom"                |
| InflationRateChange | string (dec)    | "0.130000000000000000" |
| InflationMax        | string (dec)    | "0.200000000000000000" |
| InflationMin        | string (dec)    | "0.070000000000000000" |
| GoalBonded          | string (dec)    | "0.670000000000000000" |
| BlocksPerYear       | string (uint64) | "6311520"              |
