pragma solidity ^0.4.0;

contract Token {
    // 总供应量
    uint256 public totalSupply;

    // balancdOf 查询余额
    // @param _owner 地址
    // @return balance 余额
    function balanceOf(address _owner) public view returns (uint256 balance);

    // transfer 转账
    // @param _to 转给谁
    // @param _value 转多少
    // @return success 是否成狗
    function transfer(address _to, uint256 _value) public returns (bool success);

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);

    function approve(address _spender, uint256 _value) public returns (bool success);

    function allowance(address _owner, address _spender) public view returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract TokenDemo is Token {

    string public name;  // 名称
    uint8 public decimals; // 返回token 返回小数点后几位
    string public symbol; // token简称， like MTT


    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;

    // ???
    address owner;
    constructor() public {
        owner = msg.sender;
    }

    // 构造函数，创建代币
    function TokenDemo(uint256 _initialAmount, string _tokenName, uint8 _decimalUints, string _tokenSymbol) public {
        // 设置初始总量
        totalSupply = _initialAmount * 10 ** uint256(_decimalUints);

        // 初始化token数量给予消息发送者，以为是构造函数， 所以这里也是创建者
        // ???
        balances[msg.sender] = totalSupply;

        name = _tokenName;
        decimals = _decimalUints;
        symbol = _tokenSymbol;
    }

    // 转账
    function transfer(address _to, uint256 _value) public returns (bool success) {
        // 默认totalSupply 不会超过最大值（ 2 ^ 256 -1）
        // 如果随着时间推移将会有新的代币产生，可以用下面语句避免溢出异常
        require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
        require(_to != 0x0);

        // 从消息账户中减去_value
        balances[msg.sender] -= _value;
        // 接受账户中增加 _value
        balances[_to] += _value;
        // 触发转账事件
        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);

        balances[_to] += _value;

        balances[_from] -= _value;

        allowed[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    // 查询余额
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public returns (bool success){

        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remainning) {
        return allowed[_owner][_spender];
    }

}