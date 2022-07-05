## commond模块  
xuperos/commomd   

目录：  
- const.go  
    引擎名常量,广播模式常量
    * BCEngineName = "xchain"
    * 完全广播模式/ 问询模式
- context.go  
    定义了引擎运行上下文结构体 与链级别上下文结构体
    * type EngineCtx struct
    * type ChainCtx struct
- error.go  
    标准错误码定义，错误结构体
    * type Error struct 
- interface.go
    定义了链接口，链管理接口，链依赖组件接口，
    引擎接口，引擎依赖组件接口，
    异步任务依赖接口    
---
## 重点1：引擎与链的上下文结构体
**type EngineCtx struct**  // 引擎运行上下文环境  
```
 type EngineCtx struct {
    // 基础上下文
    xctx.BaseCtx
    // 运行环境配置
    EnvCfg *xconf.EnvConf
    // 引擎配置
    EngCfg *engconf.EngineConf
    // 网络组件句柄
    Net network.Network
    // 链管理上下文
    ChainM ChainManager
 }
```
    
**type ChainCtx struct** //链级别上下文，维护链级别上下文，每条平行链各有一个  
``` 
type ChainCtx struct {
    // 基础上下文
    xctx.BaseCtx
    // 引擎上下文
    EngCtx *EngineCtx
    // 链名
    BCName string
    // 账本
    Ledger *ledger.Ledger
    // 状态机
    State *state.State
    // 合约
    Contract contract.Manager
    // 共识
    Consensus consensus.ConsensusInterface
    // 加密
    Crypto cryptoBase.CryptoClient
    // 权限
    Acl aclBase.AclManager
    // 治理代币
    GovernToken governToken.GovManager
    // 提案
    Proposal propose.ProposeManager
    // 定时任务
    TimerTask timerTask.TimerManager
    // 结点账户信息
    Address *xaddress.Address
    // 异步任务
    Asyncworker AsyncworkerAgent
}
```   
## 重点2：链与引擎依赖的接口 
**type Engine interface**  //定义xuperos引擎对外暴露接口   
```
    type Engine interface {
    	engines.BCEngine
    	ChainManager
    	Context() *EngineCtx
    	SetRelyAgent(EngineRelyAgent) error
    }
```
**type EngineRelyAgent interface**  //定义引擎对各组件依赖接口约束      
``` 
    type EngineRelyAgent interface {
    	CreateNetwork(*xconf.EnvConf) (network.Network, error)
    }
``` 
   
**type Chain interface**   //定义链接口 
```
    type Chain interface {
    	// 获取链上下文
    	Context() *ChainCtx
    	// 启动链
    	Start()
    	// 关闭链
    	Stop()
    	// 合约预执行
    	PreExec(xctx.XContext, []*protos.InvokeRequest, string, []string) (*protos.InvokeResponse, error)
    	// 提交交易
    	SubmitTx(xctx.XContext, *lpb.Transaction) error
    	// 处理新区块
    	ProcBlock(xctx.XContext, *lpb.InternalBlock) error
    	// 设置依赖实例化代理
    	SetRelyAgent(ChainRelyAgent) error
    }
```

**type ChainRelyAgent interface** // 定义链对各组件依赖接口约束  
``` 
    type ChainRelyAgent interface {
    	CreateLedger() (*ledger.Ledger, error)  
    	CreateState(*ledger.Ledger, cryptoBase.CryptoClient) (*state.State, error)
    	CreateContract(kledger.XMReader) (contract.Manager, error)
    	CreateConsensus() (consensus.ConsensusInterface, error)
    	CreateCrypto(cryptoType string) (cryptoBase.CryptoClient, error)
    	CreateAcl() (aclBase.AclManager, error)
    	CreateGovernToken() (governToken.GovManager, error)
    	CreateProposal() (propose.ProposeManager, error)
    	CreateTimerTask() (timerTask.TimerManager, error)
    }
```
**type ChainManager interface**  // 定义管理链操作接口    
``` 
    type ChainManager interface {
    	Get(string) (Chain, error)
    	GetChains() []string
    	LoadChain(string) error
    	Stop(string) error
    }
```  
**type AsyncworkerAgent interface**  
```
    // 避免循环调用
    type AsyncworkerAgent interface {
    	RegisterHandler(contract string, event string, handler TaskHandler)
    } 
```
**type TaskContext interface**   
``` 
    type TaskContext interface {
        // ParseArgs 用来解析任务参数，参数为对应任务参数类型的指针
        ParseArgs(v interface{}) error
        RetryTimes() int
    } 
``` 