/*
* 使用 web3.js 连接区块链网络
* */

// 导入 web3 包
const Web3 = require('web3')
// rcpURL
const rpcURL = '127.0.0.1:8999'
const web3 = new Web3(rpcURL)
// 账号地址
const address = ''

// 读取 address 的余额， 单位 wei
web3.eth.getBalance(address, (err, wei) => {
    // 余额单位从 wei 转为 ether
    balance = web3.uitls.fromWei(wei, 'ether')
    console.log("balance: " + balance)
})