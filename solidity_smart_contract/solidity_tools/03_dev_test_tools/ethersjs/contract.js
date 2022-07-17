/*
    合约调用示例
 */

const assert = require('assert')

const {Contract, Wallet, getDefaultProvider} = require('ethers')

const provider = getDefaultProvider('ropsten')

const abi = [
    "event Return(uint256)",
    "function increment() returns (uint256 sum)"
]

const contractAddress = "0x..."

const contract = new Contract(contractAddress, abi)

async function increment() {

    let tx = await contract.increment()

    let receipt = await tx.wait(2)

    let sumEvent = receipt.events.pop()

    assert.equal(sumEvent.event, 'Return')
    assert.equal(sumEvent.eventSignature, 'Return(uint256)')
}

increment.then((value) => {
    console.log(value);
})