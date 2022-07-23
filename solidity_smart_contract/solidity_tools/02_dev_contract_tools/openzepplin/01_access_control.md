# 访问控制合约

## 所有权 和 `ownable`
`Ownabel` 提供了所有权合约，使用示例:
```solidity
// contract-example/MyContract.sol
// paragm solidity ^0.8.0;
import "@openzeppelin/contracts/access/OWnable.sol"

contract MyContract is Ownable {
	function normalThing() public {
		// any can call this nornalThing()
	}
	function specialThing() public onlyOwner {
		// only th owner call
	}
}
```

- `transferOwnership` 转移合约所有权
- `renounceOwnership` 对于所有者放弃这种管理特权

## 基于角色的访问控制

更加细小的颗粒度控制

### 使用示例

```solidity
// SPDX-License-Identifier: MIT
paragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20, AccessControl {
	bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
	bytes32 public constant MINTER_ROLE = keccak256("BURNER_ROLE");
	
	constructor(address minter, address burner) ERC20("MyToken","TKN"){
		_setupRole(MINTER_ROLE, minter);
		_setupRole(BURNER_ROLE, burner);
	}
	
	function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
		_mint(to, amount);
	}
	function burn(address from, uint256 amount) public onlyRole(BURNER_ROLE) {
		_burn(from, amount);
	}
	
}
```

### 授予和撤销角色

动态的管理权限

```solidity
// SPDX-License-Identifier: MIT
paragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20, AccessControl {
	bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
	bytes32 public constant MINTER_ROLE = keccak256("BURNER_ROLE");
	
	constructor() ERC20("MyToken", "TKN") {
		// 可以授予和撤销任何规则
		_setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
	}
	
    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) public onlyRole(BURNER_ROLE) {
        _burn(from, amount);
    }
}
```



## 延迟操作 delayed operation

解决行为不端的管理员攻击自己的系统。`TimelockController`正是解决这类问题。