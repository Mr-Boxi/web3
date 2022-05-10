// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


/**
    消息可以在线下进行签名， 使用合约在线上验证。


    如何进行签名和验证
     签名：
        1. 创建要签名的消息
        2. 对消息进行hash
        3. 使用私钥对 hash 签名
    
     验证：
        1. 从消息中重新计算 hash
        2. 从签名和hash 中恢复 singer
        3. 将恢复的签名者与声明的签名者进行比较
*/

contract VerifySignature {
    /* 1. Unlock MetaMask account
    ethereum.enable()
    */

    /* 2. Get message hash to sign
    getMessageHash(
        0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C,
        123,
        "coffee and donuts",
        1
    )

    hash = "0xcf36ac4f97dc10d91fc2cbb20d718e94a8cbfe0f82eaedc6a4aa38946fb797cd"
    */


    function getMessageHash(
        address _to,
        uint _amount,
        string memory _message,
        uint _nonce
    ) public pure returns(bytes32){
        return keccak256(abi.encodePacked(_to, _amount, _message, _nonce));
    }


    
}