# tendermint 共识参数配置

遇到了这样的情况，cosmos系列链通过提案修改了`BlocksPerYear`参数。目的是希望修改出块速度，但是发现出块的速度并
没有得到提升。
检查了源码才发现，cosmos-sdk 中的 `BlocksPerYear` 参数仅仅是用来修改通膨数量，和年提供量的。

查看tendermint才发现，出块数据是根据共识参数来决定。共识参数有如下字段：
```toml
#######################################################
###         Consensus Configuration Options         ###
#######################################################
[consensus]

wal_file = "data/cs.wal/wal"

# How long we wait for a proposal block before prevoting nil
# 选出 proposer 时间
timeout_propose = "3s"
# How much timeout_propose increases with each round
timeout_propose_delta = "500ms"
# How long we wait after receiving +2/3 prevotes for “anything” (ie. not a single block or nil)
# 在接收到 2/3的预投票之后等待时间
timeout_prevote = "1s"
# How much the timeout_prevote increases with each round
timeout_prevote_delta = "500ms"
# How long we wait after receiving +2/3 precommits for “anything” (ie. not a single block or nil)
# 在接收到 2/3 预提交之后等到时间
timeout_precommit = "1s"
# How much the timeout_precommit increases with each round
timeout_precommit_delta = "500ms"
# How long we wait after committing a block, before starting on the new
# height (this gives us a chance to receive some more precommits, even
# though we already have +2/3).
# 可以理解为最后的截至使时间
timeout_commit = "5s"

# How many blocks to look back to check existence of the node's consensus votes before joining consensus
# When non-zero, the node will panic upon restart
# if the same consensus key was used to sign {double_sign_check_height} last blocks.
# So, validators should stop the state machine, wait for some blocks, and then restart the state machine to avoid panic.
double_sign_check_height = 0

# Make progress as soon as we have all the precommits (as if TimeoutCommit = 0)
skip_timeout_commit = false

# EmptyBlocks mode and possible interval between empty blocks
create_empty_blocks = true
create_empty_blocks_interval = "0s"

# Reactor sleep duration parameters
peer_gossip_sleep_duration = "100ms"
peer_query_maj23_sleep_duration = "2s"
```

## 如何调整参数

这里文章详细的说了下出块流程：
https://blog.csdn.net/weixin_43988498/article/details/119031945

结合文章配置自己想要的共识参数。