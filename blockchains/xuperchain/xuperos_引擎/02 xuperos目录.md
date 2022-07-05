### xuperos 引擎目录
config 配置模块
    
    config.go   引擎配置
common 公共模块
    
    const.go    引擎名字常量配置 / 广播模式常量
    context.go  引擎和链 的上下文结构体
    error.go    引擎错误
    interface.go 公共模块-相关接口
    
    
agent 依赖模块

    chaincore.go   引擎对链核心依赖
    ledger.go      引擎对账本依赖
    rely.go        引擎对各组件依赖
   
asyncworker 异步任务模块
    
    asyncworker_impl.go  异步任务实现 
    context.go           异步任务上下文
    interface.go         异步任务接口
        
event  事件模块
    
miner 矿工模块
    
    miner.go    矿工
    vote_award  投票奖励
    
net 网络模块
    
    client.go   客户端
    error.go
    net_event.go
    validata.go
    
parachain 
    
    context.go
    parachain_contract.go
    parachain_manager.go
    
reader 读接口模块
    
    chain_info.go 
    consensus_info.go
    contract_info.go
    ledger_info.go
    utxo_info.go
    
xpb 关键信息结构模块（protobuf）
    
    xpb.proto
    xpb.pb.go   
 
 chain.go
 
 
 chainmgmt.go
 
 
 engin.go