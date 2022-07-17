# work on truffle
使用truffle开发solidity项目的工作流 --- workflow on truffle

关键点在于： step 2 , step 3

- 官网：https://trufflesuite.com/docs/truffle/
- 中文翻译: https://www.qikegu.com/docs/

## installation
```bash
npm install -g truffle

truffle --version
```
安装truffle 之后，一般会有以下套件

- node
- truffle
- ganache
- solc-js
- web3.js

## Step 1 - create a projest
```bash
mkdir boxi_test

cd boxi_test

truffle init  // 创建一个空目录
```


## Step 2 - write contracts ***

在 contracts 目录下开发自己的合约

### 安装第三方合约库 - npm

e.g 1  integrate openzeppelin
```text
npm init -y  // init project
npm i @openzeppelin/contracts
```

### 使用第三方合约库

安装第三方合约库之后, 在合约文件中使用,开发自己的合约

```sol
import "@openzeppelin/contracts/SimpleNameRegistry.sol";
```

## Step 3 - write test ***

在 test 目录下开发脚本测试,可以是 js, ts, sol

通过npm安装需要使用的的js库，例如：  harhat, ethers, web3 。

truffle 命令运行脚本： `truffle test ./path/to/test/file.js`

### write tests in js

```js
// example truffle 使用 mocha 测试框架，chai断言库 ,  web3 交互 
// 传入合约名字
const MetaCoin = artifacts.require("MetaCoin");
// Use contract() instead of describe()

contract("MetaCoin",(accounts))=> {
    it("should put 10000 MetaCoin in the first account", async () => {
        const metaCoinInstance = await MetaCoin.deploy();
        const balance = await metaCoinInstance.getBalance.call(accounts[0]);
        
        assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
    });
}
```

### write tests in solidity

#### 测试合约例子

metacoin 提供的测试合约例子 

```solidity
pragma solidity >=0.4.25 <0.6.0;

// 默认提供的断言合约， 可以导入其他的
import "truffle/Assert.sol";
import "truffle/DeployedAddress.sol";
import "../contracts/MetaCoin.sol";

contract TestMetaCoin {
	function testInitialBalanceUsingDeployedContract() {
		MeteCoin meta = MetaCoin(DeployedAddresss.MetaCoin());
		
		uint expected = 110000;
		Assert.equal(meta.getBalance(tx.origin), expectec, "Owner should have 10000 MetaCoin initially");
	}
	
	function testInitialBalanceWithNewMetaCoin() {
    	MetaCoin meta = new MetaCoin();

    	uint expected = 10000;

    	Assert.equal(meta.getBalance(tx.origin), expected, "Owner should have 10000 MetaCoin initially");
  }
}
```

#### 测试结构

- 断言 `truffle/Assert.sol`  --> Assert.equal()

- 已部署的合约使用 `truffle/DeployedAddresses.sol` -->`DeployedAddresses.<contract name>();`
- 测试合约以 `Test` 开头
- 测试函数 `test` 开头

## Step 4 - compile

编译

```bash
truffle compile
```



## Step 5 - deploy
部署