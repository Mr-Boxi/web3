# 治理合约

由 Compound 设计的GovernorAlpha 和GovernorBravo 合约非常成功和流行，其缺点是具有不同需求的项目必须分叉代码来定制代码以满足他们的需求，这可能会带来引入安全问题的高风险。对于 OpenZeppelin 合约，我们着手构建一个Governor 合约的模块化系统，这样就不需要分叉，并且可以通过使用 Solidity 继承编写小模块来适应不同的需求。您会在 OpenZeppelin Contracts 中找到开箱即用的最常见要求，但编写额外的要求很简单，我们将在未来版本中根据社区的要求添加新功能

### Tally

用于用户拥有的链上治理。它包括投票仪表板、提案创建向导、实时研究和分析以及教育内容。

## 设置治理模式

### Token

代币必须实现 ERC20Votes 扩展。防止双重投票。

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract MyToken is ERC20, ERC20Permit, ERC20Votes {
	constructor() ERC20("MyToken","MTK") ERC20Permit("MyToken"){}
	
	function _afterTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERCVotes){
		super._afterTokenTransfer(from, to, amount);
	}
	
	function _mint(address to, uint256 amount) internal override(ERC20, ERC20Votes){
		super._mint(to, amount);
	}
	
	function _burn(address account, uint256 amount) internal override(ERC20, ERC20Votes){
		super._burn(account, amount);
	}
	
	
}
```

如果项目中拥有 不包含 `ERC20Votes` 且不可以升级的令牌。 使用 `ERC20Wrapper` 包装。

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Wrapper.sol";

contract MyToken is ERC20, ERC20Permit, ERC20Votes, ERC20Wrapper {
	 constructor(IERC20 wrappedToken)
        ERC20("MyToken", "MTK")
        ERC20Permit("MyToken")
        ERC20Wrapper(wrappedToken)
    {}
    
       function _afterTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._burn(account, amount);
    }
}

```

### Governor

1. 如何确定投票权 -> 使用GovernorVotes 模块
2. 法定人数需要多少票-> 使用与 ERC20Votes 一起使用的GovernorVotesQuorumFraction 将法定人数定义为检索提案投票权的区块总供应量的百分比
3. 人们在投票时有哪些选择以及这些选票如何计数->使用 GovernorCountingSimple，该模块为选民提供 3 个选项：赞成、反对和弃权，其中只有赞成和弃权票计入法定人数
4. 应该使用什么类型的令牌进行投票->
5. 投票延迟：提案创建后多长时间应该固定投票权
6. votingPeriod：提案保持开放投票的时间。

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./governance/Governor.sol";
import "./governance/compatibility/GovernorCompatibilityBravo.sol";
import "./governance/extension/GovernorVotes.sol";
import "./governance/extension/GovernorVotesQuorumFraction.sol";
import "./governance/extension/GovernorTimelockControl.sol";

contract MyGovernor is Governor, GovernorCompatibilityBrave, GovernorVotes, GovernorVotesQuorumFraction, GovernorTimelockControl {
	constructor(Ivotes _token, TimelockController, _timelock)
		Governor("MyGovernor")
		GovernorVotes(_token)
        GovernorVotesQuorumFraction(4)
        GovernorTimelockControl(_timelock)
	{}
	   function votingDelay() public pure override returns (uint256) {
        return 6575; // 1 day
    }

    function votingPeriod() public pure override returns (uint256) {
        return 46027; // 1 week
    }

    function proposalThreshold() public pure override returns (uint256) {
        return 0;
    }

    // The functions below are overrides required by Solidity.

    function quorum(uint256 blockNumber)
        public
        view
        override(IGovernor, GovernorVotesQuorumFraction)
        returns (uint256)
    {
        return super.quorum(blockNumber);
    }

    function getVotes(address account, uint256 blockNumber)
        public
        view
        override(IGovernor, GovernorVotes)
        returns (uint256)
    {
        return super.getVotes(account, blockNumber);
    }

    function state(uint256 proposalId)
        public
        view
        override(Governor, IGovernor, GovernorTimelockControl)
        returns (ProposalState)
    {
        return super.state(proposalId);
    }

    function propose(address[] memory targets, uint256[] memory values, bytes[] memory calldatas, string memory description)
        public
        override(Governor, GovernorCompatibilityBravo, IGovernor)
        returns (uint256)
    {
        return super.propose(targets, values, calldatas, description);
    }

    function _execute(uint256 proposalId, address[] memory targets, uint256[] memory values, bytes[] memory calldatas, bytes32 descriptionHash)
        internal
        override(Governor, GovernorTimelockControl)
    {
        super._execute(proposalId, targets, values, calldatas, descriptionHash);
    }

    function _cancel(address[] memory targets, uint256[] memory values, bytes[] memory calldatas, bytes32 descriptionHash)
        internal
        override(Governor, GovernorTimelockControl)
        returns (uint256)
    {
        return super._cancel(targets, values, calldatas, descriptionHash);
    }

    function _executor()
        internal
        view
        override(Governor, GovernorTimelockControl)
        returns (address)
    {
        return super._executor();
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(Governor, IERC165, GovernorTimelockControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
```

### TimeLock

**为治理决策添加时间锁是一种很好的做法。如果用户在执行之前不同意某个决定，这允许用户退出系统。我们将结合使用 OpenZeppelin 的 TimelockController 和GovernorTimelockControl 模块**

## 提案生命周期

...