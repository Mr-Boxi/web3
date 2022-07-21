// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


/**
    库就像是合约一样， 但是不能够定义任何状态变量和发送ether

    如果所有库函数都是 internal 的，则将库嵌入到合约中。

    否则，必须先部署库，然后在部署合约之前进行链接。
*/

library SafeMath{
    function add(uint x, uint y) internal pure returns(uint){
        uint z = x + y;
        require(z >= x, "uint overflow");
        return z;
    }
}

library Math{
    function sqrt(uint y)internal pure returns (uint z){
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}

///////////////
// 使用
//////////////
contract TestSafeMath {
    using SafeMath for uint;

    uint public MAX_UINT = 2 ** 256 -1;

    function testAdd(uint x, uint y) public pure returns (uint) {
        return x.add(y);
    }

    function testSquareRoot(uint x) public pure returns (uint) {
        return Math.sqrt(x);
    }

}

library Array {
    function remove(uint[] storage arr, uint index) public {
        require(arr.length > 0, "can't remove from empty array");
        arr[index] = arr[arr.length - 1];
        arr.pop();
    }
}

contract TestArray{
    using Array for uint[];

    uint[] public arr;

    function testArrayRemove() public {
        for (uint i = 0; i < 3; i++) {
            arr.push(i);
        }

        arr.remove(1);

        assert(arr.length == 2);
        assert(arr[0] == 0);
        assert(arr[1] == 2);
    }
}


