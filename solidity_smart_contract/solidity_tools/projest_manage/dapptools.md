# work on dapptools

All you need Ethereum development tool.

github: https://github.com/dapphub/dapptools

## installation
follow github

## create project
dapp init

dapp build

dapp test

## set compiler version

在项目目录下创建 .dapprc
```text
export DAPP_SOLC_VERSION=0.8.7
```

## integrate openzeppelin
```text
nmp init -y  // init project

npm i @openzeppelin/contracts
``` 
创建 remappings.txt
```text
@openzeppelin/=node_modules/@openzeppelin/contracts
ds-test/=lib/ds-test/src/

// .daaprc
export DAPP_REMAPPING=$(cat remappings.txt)
```

## write test

code: https://github.com/t4sk/hello-dapptools  


# upgradeable contracts with openzeppelin

code:  https://github.com/t4sk/hello-oz-upgradeable

https://github.com/t4sk/hello-dapptools


# finding bug with echidan

https://github.com/crytic/echidna

# harhat
https://hardhat.org/tutorial/debugging-with-hardhat-network#solidity-console-log

# visualize solidity 