# secret_network功能模块

隐私网络是基于cosmos-sdk 进行开发的，其中大部分的功能模块都是cosmos提供的。

隐私链所用到的模块有以下这些：

- [auth](https://github.com/cosmos/cosmos-sdk/tree/v0.38.3/x/auth)
- [vesting](https://github.com/cosmos/cosmos-sdk/tree/v0.38.3/x/auth/vesting)
- [bank](https://github.com/cosmos/cosmos-sdk/tree/v0.38.3/x/bank)
- [crisis](https://github.com/cosmos/cosmos-sdk/tree/v0.38.3/x/crisis)
- [distribution](https://github.com/cosmos/cosmos-sdk/tree/v0.38.3/x/distribution)
- [evidence](https://github.com/cosmos/cosmos-sdk/tree/v0.38.3/x/evidence)
- [genutil](https://github.com/cosmos/cosmos-sdk/tree/v0.38.3/x/genutil)
- [gov](https://github.com/cosmos/cosmos-sdk/tree/v0.38.3/x/gov)
- [mint](https://github.com/cosmos/cosmos-sdk/tree/v0.38.3/x/mint)
- [params](https://github.com/cosmos/cosmos-sdk/tree/v0.38.3/x/params)
- [params client](https://github.com/cosmos/cosmos-sdk/tree/v0.38.3/x/params/client)
- [slashing](https://github.com/cosmos/cosmos-sdk/tree/v0.38.3/x/slashing)
- [staking](https://github.com/cosmos/cosmos-sdk/tree/v0.38.3/x/staking)
- [supply](https://github.com/cosmos/cosmos-sdk/tree/v0.38.3/x/supply)
- [upgrade](https://github.com/cosmos/cosmos-sdk/tree/v0.38.3/x/upgrade)
- [upgrade client](https://github.com/cosmos/cosmos-sdk/tree/v0.38.3/x/upgrade/client)

## auth

Cosmos SDK 应用程序的帐户和交易的身份验证。



auth 模块负责指定应用程序的基本交易和帐户类型。它包含中间件，其中执行所有基本交易有效性检查（签名、随机数、辅助字段），并公开帐户管理员，允许其他模块读取、写入和修改帐户。

## authz

授权账户代表其他账户执行操作。




x/authz是 Cosmos SDK 模块的一种实现，根据[ADR 30](https://docs.cosmos.network/main/docs/architecture/adr-030-authz-module.html)，它允许将任意权限从一个帐户（授予者）授予另一个帐户（被授予者）。必须使用接口的实现，为特定的 Msg 服务方法一一授予授权Authorization


## bank

代币转移功能

bank模块负责处理账户之间的多资产代币转账，并跟踪特殊情况下的伪转账，这些伪转账必须与特定类型的账户不同（特别是对归属账户的委托/取消委托）。它公开了几个具有不同功能的接口，用于与必须改变用户余额的其他模块进行安全交互。

此外，bank模块跟踪应用程序中使用的所有资产的总供应量并提供查询支持。

## capability

对象能力实现。



`x/capability`是根据[ADR 003](https://docs.cosmos.network/main/docs/architecture/adr-003-dynamic-capability-store.html)的 Cosmos SDK 模块的实现，它允许在运行时配置、跟踪和验证多所有者功能。

## crisis

在某些情况下停止区块链。



crisis模块在区块链的不变量被破坏的情况下停止区块链。可以在应用程序初始化过程中向应用程序注册不变量。

## distribution

费用分配和 Staking 代币供应分配。



这种*简单*的分配机制描述了一种在验证者和委托人之间被动分配奖励的功能性方式。请注意，该机制不会像主动奖励分配机制那样精确地分配资金，因此将来会进行升级。

- 每当提款时，必须提取他们有权获得的最大金额，而不会在池中留下任何东西。
- 每当绑定、解除绑定或将代币重新委托给现有账户时，都必须全额提取奖励（作为惰性会计规则的变化）。
- 每当验证者选择更改奖励佣金时，必须同时提取所有累积的佣金奖励。



## evidence

双重签名、不当行为等的证据处理。



`x/evidence`是一个 Cosmos SDK 模块的实现，根据[ADR 009](https://docs.cosmos.network/main/docs/architecture/adr-009-evidence-module.html)，它允许提交和处理任意的不当行为证据，例如模棱两可和反事实签名。

证据模块不同于标准证据处理，后者通常期望底层共识引擎（例如 Tendermint）通过允许客户端和外链直接提交更复杂的证据来在发现证据时自动提交证据。

所有具体的证据类型都必须实现`Evidence`接口契约。提交 `Evidence`的首先通过证据模块进行路由，在该模块`Router`中它试图找到`Handler`为该特定`Evidence`类型注册的对应。每种`Evidence`类型都必须`Handler`在证据模块的 keeper 中注册，才能成功路由和执行。

每个对应的处理程序也必须履行`Handler`接口契约。`Handler`给定类型的 `Evidence`可以执行任意状态转换，例如 slashing、jailing 和 tombstoning。

## feegrant

授予执行交易的费用津贴。请参阅[ ADR-029 ）](https://github.com/cosmos/cosmos-sdk/blob/v0.40.0/docs/architecture/adr-029-fee-grant-module.md).



该模块允许账户授予fee津贴并使用其账户中的费用。受赠者可以执行任何交易而无需维持足够的费用。

## gov

链上提案和投票。



该模块使基于 Cosmos-SDK 的区块链能够支持链上治理系统。在这个系统中，链上原生质押代币的持有者可以在 1 代币 1 票的基础上对提案进行投票。接下来是该模块当前支持的功能列表：

- **提案提交：**用户可以提交带有押金的提案。一旦达到最低存款，提案进入投票期
- **投票：**参与者可以对到达 MinDeposit 的提案进行投票
- **继承和惩罚：**如果委托人自己不投票，他们将继承他们的验证人的投票。
- **申领押金：**如果提案被接受或提案从未进入投票期，则存入提案的用户可以收回他们的押金。

## ibc

区块链间通信协议 (IBC) 允许区块链相互通信



跨链通信使用的模块。

## mint

创建新的质押代币。



铸币机制旨在：

- 允许灵活的通货膨胀率由针对特定债券比率的市场需求决定
- 实现市场流动性和质押供应之间的平衡

为了最好地确定通货膨胀奖励的适当市场利率，使用了移动变化率。移动变化率机制确保如果保税百分比高于或低于保税百分比目标，通货膨胀率将分别调整以进一步激励或抑制保税。将目标 %-bonded 设置为低于 100% 会鼓励网络维护一些非抵押代币，这将有助于提供一些流动性。

它可以通过以下方式分解：

- 如果通货膨胀率低于目标 %-bonded 通货膨胀率将增加直到达到最大值
- 如果保持目标 %bonded（Cosmos-Hub 中的 67%），那么通货膨胀率将保持不变
- 如果通货膨胀率高于目标 %-bonded 通货膨胀率将下降直到达到最小值

## params

全局可用的参数存储。



params 提供了一个全局可用的参数存储。有两种主要类型，Keeper 和 Subspace。子空间是 paramstore 的隔离命名空间，其中键以预配置的空间名称为前缀。Keeper 有权访问所有现有空间。

子空间可以由各个 Keepers 使用，这需要一个其他 Keepers 无法修改的私有参数存储。参数 Keeper 可用于向`x/gov`路由器添加路由，以便在提案通过时修改任何参数。

## slashing

验证者惩罚机制。



slashing 模块使基于 Cosmos SDK 的区块链能够通过惩罚（“slashing”）来抑制协议认可的具有风险价值的参与者的任何可归因行为。

处罚可能包括但不限于：

- 烧掉他们的一些权益
- 在一段时间内取消他们对未来区块进行投票的能力。

## staking

公共区块链的权益证明层。



该模块使基于 Cosmos-SDK 的区块链能够支持先进的权益证明系统。在这个系统中，链上原生质押代币的持有者可以成为验证者，并可以将代币委托给验证者，最终确定系统的有效验证者集。

## upgrade

软件升级处理和协调。



`x/upgrade`是 Cosmos SDK 模块的实现，它有助于将实时 Cosmos 链顺利升级到新的软件版本。它通过提供一个`BeginBlocker`钩子来实现这一点，一旦达到预定义的升级块高度，该钩子会阻止区块链状态机继续进行。

该模块没有规定任何关于治理如何决定进行升级的内容，而只是安全地协调升级的机制。如果没有软件支持升级，升级实时链是有风险的，因为所有验证者都需要在过程中完全相同的时间点暂停他们的状态机。如果没有正确完成，可能会出现难以恢复的状态不一致。



# 新增模块

## register

验证节点注册模块。



新的验证节点加入网络时候需要进行一些列的验证过程。

## compute

运行隐私合约的模块。



该模块启用秘密合约功能（包括状态的加密和解密），以及用户的加密输入/输出。