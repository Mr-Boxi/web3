### 共识框架consensus
    xupercore/kernel/consensus  
    xupercore 的共识框架  
    参考xuperchain文档
    
- interface
    
    * type ConsensusInterface interface  定义了一个共识实例需要实现的接口，用于kernel外的调用
    * type ConsensusImplInterface interface  定义了一个共识实例需要实现的接口，用于bcs具体共识的实现
    * type ConsensusStatus interface 定义了一个共识实例需要返回的各种状态，需特定共识实例实现相应接口  
    * type ConsensusCtx struct 定义一个共识运行的上下文  
    
- type  

    * type PluggableConsensus struct  
        PluggableConsensus 实现了consensus_interface接口，相关方法：  
     
        + func (pc *PluggableConsensus) makeConsensusItem(cCtx cctx.ConsensusCtx, cCfg def.ConsensusConfig) (base.ConsensusImplInterface, error)  
        + func (pc *PluggableConsensus) proposalArgsUnmarshal(ctxArgs map[string][]byte) (*def.ConsensusConfig, error)  
        + func (pc *PluggableConsensus) updateConsensus(contractCtx contract.KContext) (*contract.Response, error)  
        + func (pc *PluggableConsensus) rollbackConsensus(contractCtx contract.KContext) error  
        + func (pc *PluggableConsensus) CompeteMaster(height int64) (bool, bool, error)  
        + func (pc *PluggableConsensus) CheckMinerMatch(ctx xcontext.XContext, block cctx.BlockInterface) (bool, error)  
        + func (pc *PluggableConsensus) GetConsensusStatus() (base.ConsensusStatus, error)  
    * type stepConsensus struct   
      stepConsensus 封装了可插拔共识需要的共识数组
        + func (sc *stepConsensus) put(con ConsensusInterface) error  
        + func (sc *stepConsensus) tail() ConsensusInterface  
        + func (sc *stepConsensus) len() int  
        
    * type NewStepConsensus func(cCtx cctx.ConsensusCtx, cCfg def.ConsensusConfig) base.ConsensusImplInterface  
    
    * type ConsensusConfig struct  

- var  

    var consensusMap = make(map[string]NewStepConsensus)  
    
    结合Register()函数实现回调
    
- func
    * func NewPluggableConsensus(cCtx cctx.ConsensusCtx) (ConsensusInterface, error)  
    * func NewPluginConsensus(cCtx cctx.ConsensusCtx, cCfg def.ConsensusConfig) (base.ConsensusImplInterface, error)  
    * func checkSameNameConsensus(hisMap map[int]def.ConsensusConfig, cfg *def.ConsensusConfig) bool
    * func Register(name string, f NewStepConsensus) error
    

- 基于xupercore/kernel/consensus 共识框架实现的共识  
    pow  
    sigle  
    tdpos  
    xpoa    
