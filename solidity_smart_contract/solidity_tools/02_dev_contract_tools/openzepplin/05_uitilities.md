# 工具类合约

### 密码学

[`ECDSA`](https://docs.openzeppelin.com/contracts/4.x/utilities#api:cryptography.adoc#ECDSA)提供恢复和管理以太坊账户 ECDSA 签名的功能

[`MerkleProof`](https://docs.openzeppelin.com/contracts/4.x/utilities#api:cryptography.adoc#MerkleProof)提供：

- [`verify`](https://docs.openzeppelin.com/contracts/4.x/utilities#api:cryptography.adoc#MerkleProof-verify-bytes32---bytes32-bytes32-)- 可以证明某个值是[Merkle 树](https://en.wikipedia.org/wiki/Merkle_tree)的一部分。
- [`multiProofVerify`](https://docs.openzeppelin.com/contracts/4.x/utilities#api:cryptography.adoc#MerkleProof-multiProofVerify-bytes32-bytes32---bytes32---bool---)- 可以证明多个值是 Merkle 树的一部分。

### 内部标准

- [`IERC165`](https://docs.openzeppelin.com/contracts/4.x/utilities#api:introspection.adoc#IERC165)— 这是 ERC165 接口，它定义了[`supportsInterface`](https://docs.openzeppelin.com/contracts/4.x/utilities#api:introspection.adoc#IERC165-supportsInterface-bytes4-). 实现 ERC165 时，您将遵守此接口。
- [`ERC165`](https://docs.openzeppelin.com/contracts/4.x/utilities#api:introspection.adoc#ERC165)— 如果您想使用合约存储中的查找表支持接口检测，请继承此合约。您可以使用以下方法注册接口[`_registerInterface(bytes4)`](https://docs.openzeppelin.com/contracts/4.x/utilities#api:introspection.adoc#ERC165-_registerInterface-bytes4-)：查看示例用法作为 ERC721 实现的一部分。
- [`ERC165Checker`](https://docs.openzeppelin.com/contracts/4.x/utilities#api:introspection.adoc#ERC165Checker)— ERC165Checker 简化了检查合约是否支持您关心的接口的过程。
- 包括`using ERC165Checker for address;`
- [`myAddress._supportsInterface(bytes4)`](https://docs.openzeppelin.com/contracts/4.x/utilities#api:introspection.adoc#ERC165Checker-_supportsInterface-address-bytes4-)
- [`myAddress._supportsAllInterfaces(bytes4[\])`](https://docs.openzeppelin.com/contracts/4.x/utilities#api:introspection.adoc#ERC165Checker-_supportsAllInterfaces-address-bytes4---)

### 数学

using SafeMath for uint256;

- `myNumber.add(otherNumber)`
- `myNumber.sub(otherNumber)`
- `myNumber.div(otherNumber)`
- `myNumber.mul(otherNumber)`
- `myNumber.mod(otherNumber)`

### 支付

- `PaymentSplitter`
- `PullPayment`
- 托管 escrow

### 集合

[`EnumerableSet`](https://docs.openzeppelin.com/contracts/4.x/api/utils#EnumerableSet)和[`EnumerableMap`](https://docs.openzeppelin.com/contracts/4.x/api/utils#EnumerableMap)

### 杂项

想检查地址是否为合约？使用[`Address`](https://docs.openzeppelin.com/contracts/4.x/api/utils#Address)和[`Address.isContract()`](https://docs.openzeppelin.com/contracts/4.x/api/utils#Address-isContract-address-)。



[`Base64`](https://docs.openzeppelin.com/contracts/4.x/api/utils#Base64)util 允许您将`bytes32`数据转换为其 Base64`string`表示。



`multicall`多个调用捆绑在一个外部调用中。有了它，外部帐户可以执行包含多个函数调用的原子操作