// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 最佳单边供应
contract TestUinswapOptimalOneSidedSupply{
    address private constant FACTORY = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address private constant ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    function sqrt(uint y) private pure returns (uint z) {
        if (y > 3){
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = ( y / x + x) / 2;
            }
        }else if (y != 0){
            z = 1;
        }
    }

    /*
        s = optimal swap amount
        r = amount of reserve for token a
        a = amount of token a then user currently has (not added t reserve yet)
        f = swap fee percent
       s = (sqrt(((2 - f)r)^2 + 4(1 - f)ar) - (2 - f)r) / (2(1 - f))
    */
    function getSwapAmount(uint r, uint a) public pure returns (uint){
        return (sqrt(r * (r * 3988009 + a * 3988000)) - r * 1997) / 1994;
    }

    /*
    optimal one-sided supply
        1 swap optimal amount from tokenA to tokenB
        2 add liquidity
    */
    function zap(address _tokenA, address _tokenB, uint _amountA) external {
        require(_tokenA == WETH || _tokenB == WETH, "!weth");

        IERC20(_tokenA).transferFrom(msg.sender, address(this), _amountA);

        address pair = IUinswapV2Factory(FACTORY).getPair(_tokenA, _tokenB);

        (uint reserve0, uint reserve1,) = IUindswapV2Pair(pair).getReserves();

        uint swapAmount;
        if (IUindswapV2Pair(pair).token0() ==_tokenA) {
            // swap from token0 to token1
            swapAmount = getSwapAmount(reserve0, _amountA);
        }else {
            // swap from token1 to token0
            swapAmount = getSwapAmount(reserve1, _amountA);
        }

        _swap(_tokenA, _tokenB, swapAmount);
        _addLiquidity(_tokenA, _tokenB);
    }


    function _swap(
        address _from,
        address _to,
        uint _amount
    )
        internal
    {
        IERC20(_from).approve(ROUTER, _amount);

        address[] memory path = new address[](2);

        path = new address[](2);

        path[0] = _fron;
        path[1] = _to;

        IUinswapV2Router(ROUTER).swapExactTokensForTokens(
            _amount,
            1,
            path,
            address(this),
            block.timestamp
        );
    }


    function _addLiquidity(address _tokanA, address _tokenB) internal {
        uint balA = IERC20(_tokanA).balanceOf(address(this));
        uint balB = IERC20(_tokenB).balanceOf(address(this));
        IERC20(_tokanA).approve(ROUTER, balA);
        IERC20(_tokenB).approve(ROUTER,balB);

        IUinswapV2Router(ROUTER).addrLiquidity(
            _tokanA,
            _tokenB,
            balA,
            balB,
            0,
            0,
            address(this),
            block.timestamp
        );
    }
}

interface IUinswapV2Router{
    function addrLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    )
        external
        returns
    (
        uint amountA,
        uint amountB,
        uint liquidity
    );

    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    )
        external
        returns
    (
        uint[] memory amounts
    );
}

interface IUinswapV2Factory {
    function getPair(address token0, address token1) external view returns (address);
}

interface IUindswapV2Pair {
    function token0() external view returns(address);
    function token1() external view returns(address);

    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
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
}