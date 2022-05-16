# secretd_network 业务梳理

这条链可以做什么？ 查看tx有什么命令基本就可以确定可以做什么。

## authz 模块

将任意权限从一个账户授予(授予者)给另一个账户(被授予者)。

### 内置授权

1. 通用授权

`GenericAuthorization`实现`Authorization`接口，该接口授予代表授予者帐户执行提供的 Msg 的不受限制的权限。相当于完全授权

2. 发送授权

`SendAuthorization`实现Msg的`Authorization`接口。`cosmos.bank.v1beta1.MsgSend`它需要一个（正数）`SpendLimit`来指定受让人可以花费的最大代币数量。

3. 权益授权

`StakeAuthorization`实现[质押模块](https://docs.cosmos.network/v0.44/modules/staking/)`Authorization`中的消息接口. 需要`AuthorizationType`指定您是否要授权委托、取消委托或重新委托（即这些必须单独授权）。它还需要`MaxTokens`跟踪可以委托/取消委托/重新委托的令牌数量的限制。如果留空，则金额不受限制。

### Clinet使用

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

## bank 模块

处理账户之间多资产代币转账，bank模块跟踪应用程序中使用的所有资产的总供应量并提供查询支持。

### CLI

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

## broadcast



## compute



## crisis 模块

在区块链不变量被破坏的情况下停止区块链。可以在应用程序初始化过程中向应用程序注册不变量。

### CLI

在不变量被破环的时候提交证明

```bash
secretd tx crisis invariant-broken [module-name] [invariant-route] [flags]

# example  例如 bank 的总供应量被破坏
secretd tx crisis invariant-broken bank total-supply --from=[keyname or address]
```



## decode



## evidence



## feegrant

### CLI

#### Query

```bash
secretd query feegrant grant [granter] [grantee] [flags]
```

#### Transaction

grant 授予指令允许用户向另一个帐户授予费用津贴。费用津贴可以有截止日期、总支出限制和/或定期支出限制。

```bash
secretd tx feegrant grant [granter] [grantee] [flags]

# example 
# 一次花费上限
secretd tx feegrant grant cosmos1.. cosmos1.. --spend-limit 100stake

# 定额限制
secretd tx feegrant grant cosmos1.. cosmos1.. --period 3600 --period-limit 10stake

```

revoke 撤销对用户的费用津贴。

```bash
secretd tx feegrant revoke [granter] [grantee] [flags]

# example
secretd tx feegrant revoke cosmos1.. cosmos1..
```

## gov

治理模块。查看治理模块命令使用。

## ibc



## ibc-transfer



## icamsgauth

## multisign

多签命令。

## register

## sign

## sign-batch

## sign-doc

## slashing 模块

惩罚机制

- 撤销权益
- 取消一段时间内投票的能力

### CLI

#### Query

params 命令查询创世文件shashing模块的参数

```bash
secretd query slashing params [flags]
```

#### Transaction

unjail  取消之前因为停机的惩罚

```bash
secretd tx slashing unjail --from mykey [flags]
```

## snip20

## staking

### CLI

#### Query

#### Transactions

create-validator 允许用户创建用自我委托初始化的新验证器。

```bash
secreted tx staking create-validator [flags]

# example
secreted tx staking create-validator \
  --amount=1000000stake \
  --pubkey=$(secreted tendermint show-validator) \
  --moniker="my-moniker" \
  --website="https://myweb.site" \
  --details="description of your validator" \
  --chain-id="name_of_chain_id" \
  --commission-rate="0.10" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1" \
  --gas="auto" \
  --gas-adjustment="1.2" \
  --gas-prices="0.025stake" \
  --from=mykey
```

delegate  允许用户委托原生代币给验证器

```bash
secreted tx staking delegate [validator-addr] [amount] [flags]

# example
secreted tx staking delegate cosmosvaloper1l2rsakp388kuv9k8qzq6lrm9taddae7fpx59wm 1000stake --from mykey
```

edit-validator 允许用户修改验证器别名

```bash
secreted tx staking edit-validator [flags]

# example
secreted tx staking edit-validator --moniker "new_moniker_name" --website "new_webiste_url" --from mykey
```

redelegate 允许用户重新委托代币给另一个验证器。

```bash
secreted tx staking redelegate [src-validator-addr] [dst-validator-addr] [amount] [flags]

# example
secreted tx staking redelegate cosmosvaloper1gghjut3ccd8ay0zduzj64hwre2fxs9ldmqhffj cosmosvaloper1l2rsakp388kuv9k8qzq6lrm9taddae7fpx59wm 100stake --from mykey
```

unbond  与验证器解除共享

```bash
secreted tx staking unbond [validator-addr] [amount] [flags]

# example
secreted tx staking unbond cosmosvaloper1gghjut3ccd8ay0zduzj64hwre2fxs9ldmqhffj 100stake --from mykey
```

cancel unbond  允许用户取消未绑定的委托并委托会原始的验证器

```bash
secreted tx staking cancel-unbond [validator-addr] [amount] [creation-height]

# example
secreted tx staking cancel-unbond cosmosvaloper1gghjut3ccd8ay0zduzj64hwre2fxs9ldmqhffj 100stake 123123 --from mykey

```

## validata-signatures



## vesting



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

consensus_params , 设置区块和验证器

### 各给模块的初始参数

参考上面模块。

```
auth, authz, bank, capability, compute, crisis, distribution, evidence, feegrant, genutil, gov, ibc,  icamsgauth, interchainaccounts, mint, params, register, shashing, transfer, 
upgrade, vesting
```



