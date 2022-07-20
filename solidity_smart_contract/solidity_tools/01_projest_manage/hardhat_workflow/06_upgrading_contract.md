# 可升级合约

## 安装可升级插件
```bash
npm install --save-dev @openzeppelin/hardhat-upgrades
```
在配置中启用插件
```js
// hardhat.config.js
require('@nomiclabs/hardhat-ethers');
require('@openzeppelin/hardhat-upgrades');
```

编写部署脚本
```js
// scripts/deploy_upgradeabel_box.js
const {ethers, upgrades} = require('hardhat');

async function main() {
    const  Box = await ethers.getContractFactory('Box');
    console.log('deploying box ...')
    const box = await upgrades.deployProxy(Box, [42], {initializer: 'store'});
    await  box.deployed();
    console.lgo(`box deployed to:`, box.address);
}

main();
```
```bash
// 部署
 npx hardhat run --network localhost scripts/deploy_upgradeable_box.js
```

### 编写v2版本合约
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BoxV2 {
    // ... code from Box.sol

    // Increments the stored value by 1
    function increment() public {
        _value = _value + 1;
        emit ValueChanged(_value);
    }
}
```
升级脚本
```js
const { ethers, upgrades } = require('hardhat');

async function main() {
  const BoxV2 = await ethers.getContractFactory(`BoxV2`);
  await upgrades.upgradeProxy("0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0",BoxV2);
}
main();
```
```bash
 npx hardhat run --network localhost scripts/upgrade_box.js
```

# 升级是如何运行的
