/*
  web3 交易操作
        交易操作是指会把数据写入区块链，改变区块链状态的操作.
        转账
        调用合约写函数
        部署合约
        ...
 */

// npm install ethereumjs-tx
// 用来本地签署交易
// 创建tx  -> 签名tx -> 广播tx
var Tx = require('ethereumjs-tx').Transaction

// 建立一个 web3 连接
const Web3 = require('Web3')
const web3 = new web3('https://ropsten.infura.io/YOUR_INFURA_API_KEY')

// web3.eth.accounts.create()
// 账号
const account1 = '0xf4Ab5314ee8d7AA0eB00b366c52cEEccC62d6B4B'
const account2 = '0xff96B8B43ECd6C49805747F94747bFfa3A960b69'

// 账号私钥
const privateKey1 = process.env.PRIVATE_KEY_1
const privateKey2 = process.env.PRIVATE_KEY_2

// 构建交易对象
web3.eth.getTransactionCount(account1, (err, txCount) => {
    const txObject = {
        nonce: web3.utils.toHex(txCount),
        to: account2,
        value: web3.uitls.toHex(web3.utils.toWei('0.1', 'ether')),
        gasLimit: web3.utils.toHex(21000),
        gasPrices: web3.utils.toHex(web3.utils.toWei('10', 'gwei'))
    }

    // 签署交易
    const tx = new Tx(txObject, {chain: 'ropsten', hardfork: 'petersburg'})
    tx.sign(privateKey1)

    const serizlizedTx = tx.serialize()
    const raw = '0x' + serizlizedTx.toString('hex')

    //广播交易
    web3.eth.sendSignedTransaction(raw, (err, txHash) => {
        console.log("txHash: ", txHash)
    })
})




