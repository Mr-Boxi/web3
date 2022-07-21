### ERC20

https://blog.csdn.net/pony_maggie/article/details/79588259
```
contract ERC20 {
    function name constant returns (string name);
    function symbol() constant returns (string symbol);
    function decimals() constant returns (uint8 decimals);
    function totalSupply() constant returns (uint totalSupply);
    function balanceOf(address _owner) constant returns (uint balance);
    function transfer(address _to, uint _value) returens (bool success);
    function transferFrom(address _form address _to, uint _value) returns (bool success);
    function approve(address _spender, uint _value) returns (bool success);
    
    event Transfer(address indeced _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
} 
```
./bin/xchain-cli evm invoke --method NewTokenDemo -a '{"_initialAmount":"100","_tokenName":"boix","_decimalUints":"3","_tokenSymbol":"BX"}' tokenevm --fee 1000000 --abi TokenDemo.abi


https://mp.weixin.qq.com/s/foM1QWvsqGTdHxHTmjczsw

https://github.com/Giveth/minime/blob/master/contracts/MiniMeToken.sol
