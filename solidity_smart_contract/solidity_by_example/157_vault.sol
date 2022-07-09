// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/*
how the contract works
    1 用户存款时会铸造一些股份。
    2 DeFi 协议将使用用户的存款来产生收益（以某种方式）
    3 用户烧掉股份以提取他的代币+收益
*/
contract Vault {
    IERC20 public immutable token;

    uint public totalSupply;

    mapping(address => uint) public balanceOf;

    constructor(address _token) {
        token = IERC20(_token);
    }


    function _mint(address _to, uint _shares) private {
        totalSupply += _shares;
        balanceOf[_to] += _shares;
    }

    function _burn(address _from, uint _shares) private {
        totalSupply -= _shares;
        balanceOf[_from] -= _shares;
    }

    function deposit(uint _amount) external {
        /*
        a = amount
        B = balance of token before deposit
        T = total totalSupply
        s = shares to mint

        (T + S) / T = (a + B) / B

        s = aT / B
        */

        uint shares;
        if (totalSupply == 0) {
            shares = _amount;
        }else{
            shares = (_amount * totalSupply) / token.balanceOf(address(this));
        }

        _mint(msg.sender, shares);
        token.transferFrom(msg.sender, address(this), _amount);
    }

    function withdraw(uint _shares) external {
        uint amount = (_shares * token.balanceOf(address(this))) / totalSupply;
        _burn(msg.sender, _shares);
        token.transfer(msg.sender, amount);
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint amount);
    event Approval(address indexed owner, address indexed spender, uint amount);
}