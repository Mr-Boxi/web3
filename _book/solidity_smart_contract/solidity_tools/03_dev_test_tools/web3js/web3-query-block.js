/*
    web3js  查询区块
 */

const Web3 = require('web3')
const web3 = new Web3('https://mainnet.infura.io/v3/YOUR_INFURA_API_KEY') // YOUR_INFURA_API_KEY替换为你自己的key

// 查询最新区块号
web3.eth.getBlockNumber().then(console.log)

// 最新区块
web3.eth.getBlock('latest').then(console.log)

// 查询指定哈希值的区块
web3.eth.getBlock('0x25d9f9dd736ebaac3c99cb0edb5df22745c354d208c6e2b5b43f426f754adfbe').then(console.log)

// 查询指定序号区块
web3.eth.getBlock(0).then(console.log)

// 查询某个区块中的指定交易信息
const hash = '0x66b3fd79a49dafe44507763e9b6739aa0810de2c15590ac22b5e2f0a3f502073'
web3.eth.getTransactionFromBlock(hash, 2).then(console.log)