// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/**
    Multi-Sig wallet  多签钱包

    钱包拥有者可以：
        - 提交一笔交易
        - 对打包的交易 授权或者撤销授权
        - 在足够多的所有者批准后，任何人都可以执行交易。
    
*/