# 跨链合约

*构建由外部链上的管理者控制的可升级和可铸造的 ERC20 代币*。

### ERC20合约

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract MyToken is Initializable, ERC20Upgradeable, UUPSUpgradeable {
	address public owner;
	
	modifier onlyOwner() {
		require(owner == _msgSender(), "Not authorized");
		_;
	}
	
	constructor() initializer{}
	function initialize(address initialOwner) initializer public {
		__ERC20_init("MyToken", "MTK");
        __UUPSUpgradeable_init();

        owner = initialOwner;
	}
	
	 function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {
    }
}
```



```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlCrossChainUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

abstract contract MyTokenCrossChain is Initializable, ERC20Upgradeable, AccessControlCrossChainUpgradeable, UUPSUpgradeable {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function initialize(address initialOwner) initializer public {
        __ERC20_init("MyToken", "MTK");
        __AccessControl_init();
        __UUPSUpgradeable_init();

        _grantRole(_crossChainRoleAlias(DEFAULT_ADMIN_ROLE), initialOwner); // initialOwner is on a remote chain
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    function _authorizeUpgrade(address newImplementation) internal onlyRole(UPGRADER_ROLE) override {
    }
}

import "@openzeppelin/contracts-upgradeable/crosschain/amb/CrossChainEnabledAMB.sol";

contract MyTokenXDAI is
    MyTokenCrossChain,
    CrossChainEnabledAMB(0x75Df5AF045d91108662D8080fD1FEFAd6aA0bb59)
{}

import "@openzeppelin/contracts-upgradeable/crosschain/optimismCrossChainEnabledOptimism.sol";

contract MyTokenOptimism is
    MyTokenCrossChain,
    CrossChainEnabledOptimism(0x25ace71c97B33Cc4729CF772ae268934F7ab5fA1)
{}
```

