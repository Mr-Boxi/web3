# secret_newwork 命令使用

本教程主要是介绍 secretcli 的使用。secretcli 是一个命令行工具，用于与节点之间的交互。

# 配置CLI

```bash
# 客户端配置文件路径 ~/.secretd/config/client.toml
# 目前的测试网链名为secretdev-1
# 配置链名
secretcli config chain-id secretdev-1
# 配置输出格式
secretcli config output json
# 配置请求节点rpc,目前cli和几点都是一个机器上 
secretcli config node http://127.0.0.1:26657
```

# 使用CLI

## key 命令

secret 有4种类型的key。

- secret 
  - 重`secretcli keys add`生成的账号派生的key
  - 用于接收资金
  - 例如`secret15h6vd5f0wqps26zjlwrc6chah08ryu4hzzdwhc`
- secretvaloper
  -  用于关联操作人与验证器
  -  用于执行质押命令
  -  例如 `secretvaloper1carzvgq3e6y3z5kz5y6gxp3wpy3qdrv928vyah`
- secretpub
  - 从`secretcli keys add`生成的账号中派生处理的key
  - `secretpub1zcjduc3q7fu03jnlu2xpl75s2nkt7krm6grh4cc5aqth73v0zwmea25wj2hsqhlqzm`
- `secretvalconspub`
  - 节点在`secretd init`初始化的时候生成
  - 可以使用这个命令获得`secretd tendermint show-validator`
  - `secretvalconspub1zcjduepq0ms2738680y72v44tfyqm3c9ppduku8fs6sr73fx7m666sjztznqzp2emf`

### 创建key

为了能够接收资金和发送交易，通常是要创建一个账号,这个账号包括公钥和私钥。

```bash
secretcli keys add <key-alias>
```

这个命令会输出一个助记词，需要自己保存在安全的地方。

当忘记公司要的时候，可以使用助记词恢复账号。

###  恢复key

```bash
secretcli keys add --recover <key-alias>
```

### 导出key备份

```bash
secretcli keys export <key-alias>
# 将打印账号的信息，复制并写到自己的备份文件中
```

### 导入key

```bash
secretcli keys import <key-alias> <key-export-file>
```

### 查看key

```bash
secretcli keys show <key-alias>
# 如果仅仅查看地址添加 -a 参数，如下
secretcli keys show <key-alias> -a
# 查看所有可以的key
secretcli keys list
```

### 查看验证器操作地址

```bash
secretcli keys show <key-alias> --bech=val
```

### 查看验证器的公钥

```bash
secretd tendermint show-validator
```

### 生成多签的公钥

```bash
secretcli keys add --multisig=name1,name2,name3[...] --multisig-threshold=K <new-key-alias>
```

- --multisig-threshold=K ，K 表示至少有多少个签名
- --multisig 包含签名列表

```bash
secretcli keys add --multisig=foo,bar,baz --multisig-threshold=2 multisig-A
```

- multisig-A 发送的交易，至少需要 foo,bar,baz 中的两个人签名



## Account 命令

### 查询账号余额

```bash
secretcli query bank balance <secret-address>
```

或者直接使用下面命令

```bash
secretcli query bank balances $(secretcli keys show -a <key-alias>)
```

### 发送原生token

```bash
secretcli tx bank send <sender-key-alias-or-address> <recipient-address> 10uscrt
```

同样的可以使用 `--generate-only` 生成不签名的tx

```bash
secretcli tx bank send <sender-key-alias-or-address> <recipient-address> 10uscrt \
  --chain-id=<chain-id> \
  --generate-only > unsignedSendTx.json
```

然后签名

```bash
secretcli tx sign \
  --chain-id=<chain-id> \
  --from=<key-alias> \
  unsignedSendTx.json > signedSendTx.json
```

检查tx

```bash
secretcli tx sign --validate-signatures --from=<key-alias> signedSendTx.json
```

发送tx

```bash
secretcli tx broadcast --node=<node> signedSendTx.json
```

## 合约命令

### 上传合约

```bash
secretcli tx compute store  ./contract.wasm.gz --from mykey --source "https://github.com/<username>/<repo>/tarball/<version>" --builder "enigmampc/secret-contract-optimizer:1.0.2"
```

- --source: 源码可选压缩包
- --builder: 用于编译的可选docker镜像。 可重现构建。

获取合约代码id

```bash
secretcli q tx [hash]
```

### 部署合约

```bash
secretcli tx compute instantiate $CODE_ID "$INIT_INPUT_MSG" --from mykey --label "$UNIQUE_LABEL"
```

获取合约地址

```bash
secretcli q tx [hash]
```

### 调用合约

```bash
secretcli tx compute execute $CONTRACT_ADDRESS "$EXEC_INPUT_MSG"
```

或者：

```bash
secretcli tx compute execute --label "$UNIQUE_LABEL" "$EXEC_INPUT_MSG"
```

### 查询合约

```bash
secretcli q compute query $CONTRACT_ADDRESS "$QUERY_INPUT_MSG"
```

```bash
secretcli q compute tx [hash]
```



## 质押(staking)



##  铸币（minting）



## 惩罚 (Slashing)



## 费用分配(fee distribution)



# 治理(governance)

链的治理十分重要，所以将治理标题提升一级。

隐私网络通过治理提案来决定主网参数、软件升级、信号机制等。持有原生代币的人可以对提案进行投票。

投票细节：

- 1 个原生代币一票
- 如果委托人不投票，他们将继承其验证人的投票。

- `(YesVotes / (YesVotes+NoVotes+NoWithVetoVotes)) > 1/2` ([threshold](https://github.com/scrtlabs/SecretNetwork/blob/b0792cc7f63a9264afe5de252a5821788c21834d/enigma-1-genesis.json#L1864))
- `(NoWithVetoVotes / (YesVotes+NoVotes+NoWithVetoVotes)) < 1/3` ([veto](https://github.com/scrtlabs/SecretNetwork/blob/b0792cc7f63a9264afe5de252a5821788c21834d/enigma-1-genesis.json#L1865))
- `((YesVotes+NoVotes+NoWithVetoVotes) / totalBondedStake) >= 1/3` ([quorum](https://github.com/scrtlabs/SecretNetwork/blob/b0792cc7f63a9264afe5de252a5821788c21834d/enigma-1-genesis.json#L1863))

### 创建治理提案

为了创建治理提案，您必须提交初始存款以及标题和描述。目前，为了进入投票期，提案必须在一周内累积至少[100`SCRT`](https://secretnodes.com/secret/chains/secret-4/governance/proposals/32)的存款。

治理之外的各种模块可以实现自己的提案类型和处理程序（例如参数更改），其中治理模块本身支持`Text`提案。治理之外的任何模块都将命令在`submit-proposal`.

####  text 提案

提交 text提案

```bash 
secretcli tx gov submit-proposal \
  --title <title> \
  --description <description> \
  --type Text \
  --deposit 100000000uscrt \
  --from <key_alias>
```

可以通过`--proposal`指向包含提案的 JSON 文件的标志直接提供提案：

```bash
secretcli tx gov submit-proposal --proposal <path/to/proposal.json> --from <key_alias>
```

`proposal.json`

```json
{
  "type": "Text",
  "title": "My Cool Proposal",
  "description": "A description with line breaks \n and `code formatting`",
  "deposit": "100000000uscrt"
}
```

#### 主网参数更改提案

要提交参数更改提案，您必须提供提案文件。

```bash
secretcli tx gov submit-proposal param-change <path/to/proposal.json> --from <key_alias>
```

`proposal.json`

```json
{
  "title": "Param Change",
  "description": "Update max validators with line breaks \n and `code formatting`",
  "changes": [
    {
      "subspace": "Staking",
      "key": "MaxValidators",
      "value": 105
    }
  ],
  "deposit": "10000000uscrt"
}
```

#### 主网参数可更改列表

| Subspace       | Key                       | Type              | Example                                                      |
| -------------- | ------------------------- | ----------------- | ------------------------------------------------------------ |
| `auth`         | `MaxMemoCharacters`       | string (uint64)   | `"256"`                                                      |
| `auth`         | `TxSigLimit`              | string (uint64)   | `"7"`                                                        |
| `auth`         | `TxSizeCostPerByte`       | string (uint64)   | `"10"`                                                       |
| `auth`         | `SigVerifyCostED25519`    | string (uint64)   | `"590"`                                                      |
| `auth`         | `SigVerifyCostSecp256k1`  | string (uint64)   | `"1000"`                                                     |
| `baseapp`      | `BlockParams`             | object            | `{"max_bytes":"10000000","max_gas":"10000000"}`              |
| `baseapp`      | `EvidenceParams`          | object            | `{"max_age_num_blocks":"100000","max_age_duration":"172800000000000","max_bytes":"50000"}` |
| `baseapp`      | `ValidatorParams`         | object            | `{"pub_key_types":["ed25519"]}`                              |
| `bank`         | `sendenabled`             | bool              | `true`                                                       |
| `crisis`       | `ConstantFee`             | object (coin)     | `{"denom": "uscrt", "amount": "1000"}`                       |
| `distribution` | `communitytax`            | string (dec)      | `"0.020000000000000000"`                                     |
| `distribution` | `secretfoundationtax`     | string (dec)      | `"0.030000000000000000"`                                     |
| `distribution` | `secretfoundationaddress` | string            | `"secret164z7wwzv84h4hwn6rvjjkns6j4ht43jv8u9k0c"`            |
| `distribution` | `baseproposerreward`      | string (dec)      | `"0.010000000000000000"`                                     |
| `distribution` | `bonusproposerreward`     | string (dec)      | `"0.040000000000000000"`                                     |
| `distribution` | `withdrawaddrenabled`     | bool              | `true`                                                       |
| `evidence`     | `MaxEvidenceAge`          | string (time ns)  | `"120000000000"`                                             |
| `gov`          | `depositparams`           | object            | `{"min_deposit": [{"denom": "uscrt", "amount": "10000000"}], "max_deposit_period": "172800000000000"}` |
| `gov`          | `votingparams`            | object            | `{"voting_period": "172800000000000"}`                       |
| `gov`          | `tallyparams`             | object            | `{"quorum": "0.334000000000000000", "threshold": "0.500000000000000000", "veto": "0.334000000000000000"}` |
| `mint`         | `MintDenom`               | string            | `"uscrt"`                                                    |
| `mint`         | `InflationRateChange`     | string (dec)      | `"0.080000000000000000"`                                     |
| `mint`         | `InflationMax`            | string (dec)      | `"0.150000000000000000"`                                     |
| `mint`         | `InflationMin`            | string (dec)      | `"0.070000000000000000"`                                     |
| `mint`         | `GoalBonded`              | string (dec)      | `"0.670000000000000000"`                                     |
| `mint`         | `BlocksPerYear`           | string (uint64)   | `"6311520"`                                                  |
| `slashing`     | `SignedBlocksWindow`      | string (int64)    | `"5000"`                                                     |
| `slashing`     | `MinSignedPerWindow`      | string (dec)      | `"0.500000000000000000"`                                     |
| `slashing`     | `DowntimeJailDuration`    | string (time ns)  | `"600000000000"`                                             |
| `slashing`     | `SlashFractionDoubleSign` | string (dec)      | `"0.050000000000000000"`                                     |
| `slashing`     | `SlashFractionDowntime`   | string (dec)      | `"0.010000000000000000"`                                     |
| `staking`      | `UnbondingTime`           | string (time ns)  | `"259200000000000"`                                          |
| `staking`      | `MaxValidators`           | uint16            | `100`                                                        |
| `staking`      | `KeyMaxEntries`           | uint16            | `7`                                                          |
| `staking`      | `HistoricalEntries`       | uint16            | `3`                                                          |
| `staking`      | `BondDenom`               | string            | `"uscrt"`                                                    |
| `ibc`          | `AllowedClients`          | object (string[]) | `["07-tendermint"]`                                          |
| `ibc`          | `MaxExpectedTimePerBlock` | uint64            | `"30000000000"`                                              |
| `transfer`     | `SendEnabled`             | bool              | `true`                                                       |
| `transfer`     | `ReceiveEnabled`          | bool              | `true`                                                       |



#### 软件升级提案

目前不支持



### 查询提案

创建提案之后可以通下面命令查询：

```bash
secretcli query gov proposal <proposal_id>
```

查询所有可用的提案：

```bash
secretcli query gov proposals
```

查询提案者

```bash
secretcli query gov proposer <proposal_id>
```

### 查询存款

查询提案存款

```bash
secretcli query gov deposits <proposal_id>
```

查询特定地址的村困

```bash
secretcli query gov deposit <proposal_id> <depositor_address>
```

### 增加提案存款

如果提案的存款值达不到 `minDeposit`,提案不会被激活。

```bash
secretcli tx gov deposit <proposal_id> "10000000uscrt" --from <key_alias>
```

### 对提案进行投票

在存款达到`MinDeposit`之后，投票期开始。使用下面命令投票

```
secretcli tx gov vote <proposal_id> <Yes/No/NoWithVeto/Abstain> --from <key_alias>
```

### 查询投票

查看投票人票数

```bash
secretcli query gov vote <proposal_id> <voter_address>
```

查询所有投票

```bash
secretcli query gov votes <proposal_id>
```

### 查询提案统计结果

```bash
secretcli query gov tally <proposal_id>
```

### 查询治理模块参数

当前治理参数

```bash
secretcli query gov params
```

查询治理参数子集

```bash
secretcli query gov param voting
secretcli query gov param tallying
secretcli query gov param deposit
```

