# 可升级的erc20合约

### 合约编写

```solidity
// SPDX-License-Identifier: MIT

import "openzeppelin/contracts-upgradeable/token/ERC20Upgradeable.sol";
import "openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract MyTokenUpgradeable is Initializable,ERC20Upgradeable, OwnableUpgradeable {
	
	// only be call once (**)
	function initialize() external initializer {
		_ERC20_init("mytoken","my");
		_Ownable_init();
	}
	
	function mint(address to, uint amount) external onlyOwner {
		_mint(to, amount);
	}
}
```