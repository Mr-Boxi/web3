## agent模块  
xuperos/agent  
代理依赖组件， 结合公共模块的接口阅读

目录：  
- chaincore.go  
    定义链核心服务结构体， 继承链上下文结构体
    * type ChainCoreAgent struct
- ledger.go  
    定义账本代理结构体，继承链上下文结构体
    * type LedgerAgent struct
- rely.go    
    引擎依赖代理组件 EngineRelyAgentImpl, 继承引擎接口   
    链依赖代理组件  ChainRelyAgentImpl, 继承链接口
    
    * type EngineRelyAgentImpl struct 
    * type ChainRelyAgentImpl struct
  
### 结构体如下
**type EngineRelyAgentImpl struct**  //引擎代理依赖组件实例化操作   
```
type EngineRelyAgentImpl struct {
    engine common.Engine
} 
//对引擎进行接口进行封装一层
```
* func NewEngineRelyAgent(engine common.Engine) *EngineRelyAgentImpl   
* func (t *EngineRelyAgentImpl) CreateNetwork(envCfg *xconf.EnvConf) (network.Network, error) //创建并启动p2p网络     

**type ChainRelyAgentImpl struct**   //代理依赖组件实例化操作，方便mock单测和并行开发  
```
type ChainRelyAgentImpl struct {
    chain common.Chain
}  
// 本质是对链接口进行一层封装
``` 

**type ChainCoreAgent struct**  //链代理
``` 
type ChainCoreAgent struct {
    log      logs.Logger
    chainCtx *common.ChainCtx  //链上下文
}
// 本质是对链上下文进行封装
// 链的上下文结构在commond模块中
```
**type LedgerAgent struct**  //账本代理
``` 
type LedgerAgent struct {
    log      logs.Logger
    chainCtx *common.ChainCtx
}
// 本质是对链上下文进行封装
```
   
 