// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/**
    Multi-Sig wallet  多签钱包

    钱包拥有者可以：
        - 提交一笔交易
        - 对打包的交易 授权或者撤销授权
        - 在足够多的所有者批准后，任何人都可以执行交易。
    
*/

contract MlutiSigWallet{
    // 存入ether事件
    event Deposit(address indexed sender, uint amount, uint balance);

    // 提交交易事件
    event SubmitTransaction(
        address indexed owner,
        uint indexed txIndex,
        address indexed to,
        uint value,
        bytes data
    );
    
    // 确认交易事件
    event ConfirmTransaction(address indexed owner, uint indexed txIndex);
    // 撤销交易事件
    event RevokeConfirmation(address indexed owner, uint indexed txIndex);
    // 执行交易事件
    event ExecuteTransaction(address indexed owner, uint indexed txIndex);

    // owner 列表
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public numConfirmationsRequired;

    struct Transaction{
        address to;
        uint value;
        bytes data;
        bool executed;
        uint numConfirmations;
    }

    // tx index => owner => bool
    mapping(uint => mapping(address => bool)) public isConfirmed;

    // 交易列表
    Transaction[] public transactions;

    // 函数修饰符
    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    modifier txExists(uint _txIndex){
        require(_txIndex < transactions.length, "tx does not exist");
        _;
    }

    modifier notExecuted(uint _txIndex){
        require(!transactions[_txIndex].executed, "tx already executed");
        _;
    }

    modifier notConfirmed(uint _txIndex){
        require(!isConfirmed[_txIndex][msg.sender],"tx already confirmed");
        _;
    }


    constructor() {
        
    }

    // todo
}