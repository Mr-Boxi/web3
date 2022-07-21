/*
    web3js 常用工具tools
 */
const Web3 = require('web3')
const web3 = new Web3('https://mainnet.infura.io/v3/YOUR_INFURA_API_KEY') // YOUR_INFURA_API_KEY替换为你自己的key


// 根据最近几个块
// 查询平均 gas prices
web3.eth.getGasPrices().then((result) => {
    console.log("wei: " + result)
    console.log("ether: " + web3.utils.fromWei(result, 'ether'))
})

// sha3, keccack256, randomHex
// web3.utils.sha3 sha256哈希
// web3.utils.keccack256
// web3.utils.randomHex  生成16进制随机数

console.log(web3.utils.sha3('boxi,hello'))
console.log(web3.utils.keccack256('boxi.hello'))
console.log(web3.utils.randomHex(32))


// underscore js lib
// web3js 附带的库， 拥有操作js的数组或对象
// 访问underscore JS库
const _ = web3.utils._
_.each({ key1: 'value1', key2: 'value2' }, (value, key) => {
    console.log(key)
})