/*
    account 使用示例
 */
const ethers = require('ethers');

//  A -> B
async function sweep(privateKey, newAddress) {

    let provider = ethers.getDefaultProvider();

    let wallet = new ethers.Wallet(privateKey, provider);

    let code = await provider.getCode(newAddress);

    if (code != '0x') { throw new Error('Cannot sweep to a contract');}

    // get the current balance
    let balance = await wallet.getBalance();


    let gasPrice = await provider.getGasPrice();

    let gasLimit = 21000;

    let value = balance.sub(gasPrice.mul(gasLimit))

    let tx = await wallet.sendTransaction({
        gasLimit: gasLimit,
        gasPrice: gasPrice,
        to: newAddress,
        value: value
    });

    console.log('sent int transaction: ' + tx.hash)
}
