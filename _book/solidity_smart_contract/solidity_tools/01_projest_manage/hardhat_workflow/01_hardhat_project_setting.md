# hardhat workflow 总结

## 创建项目

配置 `hardhat.config.js`
- npm install --save-dev @nomicfoundation/hardhat-toolbox // 必需的插件


## 配置文件
可以配置的项目：`defaultNetwork`, `networks`, `solidity`, `paths`, `mocha`

```js
module.exports = {
  defaultNetwork: "rinkeby",
  networks: {
    hardhat: {
    },
    rinkeby: {
      url: "https://eth-rinkeby.alchemyapi.io/v2/123abc123abc123abc123abc123abcde",
      accounts: [privateKey1, privateKey2, ...]
    }
  },
  solidity: {
    version: "0.5.15",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 40000
  }
}
```

## ts 项目配置

```ts
import { HardhatUserConfig } from "hardhat_workflow/config";
import "@nomicfoundation/hardhat_workflow-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.9",
};

export default config;
```

`tsconfig.json`
```json
{
  "compilerOptions": {
    "target": "es2020",
    "module": "commonjs",
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true,
    "strict": true,
    "skipLibCheck": true
  }

```