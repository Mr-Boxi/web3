# secret_network 加密方法整理

隐私网络的特点就是实现合约数据的隐私。合约执行环境是在TEE中之内，其他的特性与另外的链一致。

```
加密数据输入 ----->    TEE(执行)  ------>  加密数据输出
```

加密方法主要体现在一下方面：

- TEE 的可靠性通过称为远程证明的过程（节点参与网络所必需的）进行验证。
- 非对称密码学用于在节点和用户之间达成共识和共享秘密。
- 对称密码学用于与秘密合约用户的输入/输出加密，以及内部合约状态加密。



## 一 Enclave 中的密钥管理

节点参与网络

### 引导协议

在新网络中，第一个验证人(矿工)加入时候。

#### 初始化

1. **enclave内**

-  生成一个256为的密钥                                        // sk_v := rand()
- 生成对应公钥                                                        // pk_v := sk_v*G
- 使用 enclave 的硬件密钥加密，并保存在本地  // seal(sk_v, pk_v) 
- 生成一个 256 位的主种子                                    // seed := rand() 
-  在本地持久化主要种子                                       //  seal(seed) 
- 返回公钥和远程证明                                             //（pk_v，remote_attestation_quote）

2. **enclave外**

- 在拿到返回`（pk_v，remote_attestation_quote）` 数据，发送给因特尔的远程证明服务`IAS`,并获得一份签名报告。`(pk_v, report)`
- 广播一笔交易，内容包含：`(pk_v, report)`
- 链是：检查报告在链上是否有效。如果是，并且因为没有其他验证人，请立即批准此验证人。

#### 初始化中使用的算法

生成一对公私的算法： secp256k1

enclave 的密钥加密算法：参考英特尔技术文档-`seal 数据封装`

远程证明签名报告的算法：参考英特尔技术文档-远程证明

####  新的验证者加入（至少已有一个）

##### 阶段一

1. 查询区块链上注册表，至少有一个验证者
2. enclave内： 与上面一样*register_validator(first_validator=False)*。但不会创建/密封新种子。
3. enclave外：与上面一样，调用IAS远程证明服务。拿到报告然后广播。
4. 链上： 检查报告在链上是否有效。如果是，并且因为还有其他验证人，将新验证人移动到“等待确认”状态。

##### 阶段二

现在新的验证器挂起，假设叫v2。 已经注册的验证器称为v1。

1. v1调用 *share_key(pk_v2, report)*

- 检查v2的repost 是否有效
- ECDH 密钥派生，它创建一个新的新密钥对，并使用该密钥对和 v2 的 pubkey 生成可用于加密共享种子的对称密钥对 ( *symm_key )。*(symm_key, pk) := derived_key(pk_v2)。pk是新密钥的公钥。

- enc_seed := 加密（symm_key，种子）
- return (enc_seed, pk, proof) 

2. *将 share_seed(enc_seed, pk, proof)* tx广播到链上
3. 链上

- 存储在状态 (pk_v2 --> enc_seed) 并将赏金释放到 v1

##### 阶段三

1. 当 v2 看到 enc_seed 已被 v1 提交到链上时，他们可以在 enclave 中调用*store_seed(enc_seed, pk)*，它执行以下操作：

- symm_key := 派生密钥(sk_v2, pk)
- seed：=解密（symm_key，enc_seed）
- seal（seed）

2. 在链上发送一个*confirm_validator tx。*
3. 链上：将验证者从“待定”状态变为“已确认”状态（即完成注册）



## 二 输入/输出/状态加密/加密协议

用户与验证器的交互

已知： *(sk_io, pk_io)* --> 用于派生输入/输出密钥的共享密钥。*pk_io*在链上可用，并且*sk_io*在所有验证者的 enclave 之间共享。

### 2.1 输入加密/解密

#### 用户加密输入

1. 用户生成一个临时 secp256k1 密钥对。
2. 通过将验证者的共享公钥（*pk_io*）与临时密钥相结合，导出对称密钥。（简单的 EC 乘法 - 基本上是临时 DH）
3. 使用 AES-256-GCM对称地加密/验证交易输入。
4. 使用有效负载（contract_address、enc_func、enc_inputs、ephemeral_pubkey）创建一个计算 tx。

#### 验证器解密运算

1. 接收 tx，看看它是一个计算调用 - 将它转发到 enclave 进行处理。

2. 通过将共享密钥与 ephemeral_pubkey 应用相同的 EC 乘法，派生相同的对称密钥（我们称之为 ephemeral_secret）。

3. 密钥解密 (func, inputs) = decrypt(enc_func, enc_inputs, ephemeral_secret)。

4. 执行合约func(inputs)。

### 2.2 加密输出保存

加密输出（输出使用发送者的密钥加密）：*ephemeral_secret*来加密输出（作为合约状态的一部分存储），并且只有发送者能够解密它。

这里的挑战是 AES-256-GCM 与大多数加密一样，是一种随机算法（即，对同一消息执行两次并使用相同的密钥会导致不同的结果）。由于与 Discovery 不同，现在我们有多个验证器要处理每个计算，这意味着它们每个最终都会得到不同的结果，并且无法达成共识（在确定性输出上达成共识）。

