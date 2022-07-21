## 矿工模块
定义矿工结构体，字段是 链上下文
**type Miner struct**   //负责生产和同步区块 
```
type Miner struct {
    ctx *common.ChainCtx
    log logs.Logger
    // 矿工锁，用来确保矿工出块和同步操作串行进行
    minerMutex sync.Mutex
    // 矿工处理区块的队列
    minerQueue int64
    // 记录同步中任务目标区块高度
    inSyncHeight       int64
    inSyncTargetHeight int64
    // 记录同步中任务目标区块id
    inSyncTargetBlockId []byte
    // 标记是否退出运行
    isExit bool
    // 用户等待退出
    exitWG sync.WaitGroup
}
``` 
* func NewMiner(ctx *common.ChainCtx) *Miner  
* func (t *Miner) ProcBlock(ctx xctx.XContext, block *lpb.InternalBlock) error  
* func (t *Miner) Start()  
* func (t *Miner)ReadTermTable(ctx xctx.XContext) (bool,error)  //读term表  
* func (t *Miner)UpdateCacheTable(ctx xctx.XContext)  
* func (t *Miner) Stop()  
* func (t *Miner) IsExit() bool   
* func (t *Miner) mining(ctx xctx.XContext,flag bool) error  
* func (t *Miner) truncateForMiner(ctx xctx.XContext, target []byte) error  
* func (t *Miner) packBlock(ctx xctx.XContext, height int64,
    now time.Time, consData []byte,flag bool) (*lpb.InternalBlock, error)   
* func (t *Miner) convertConsData(data []byte) (*state.ConsensusStorage, error)   
* func (t *Miner) getTimerTx(height int64) (*lpb.Transaction, error)   
* func (t *Miner) getUnconfirmedTx(sizeLimit int) ([]*lpb.Transaction, error)   
* func (t *Miner) getAwardTx(height int64,flag bool) (*lpb.Transaction, *big.Int,error)   
* func (t * Miner)GetThawTx(height int64,ctx xctx.XContext)([]*lpb.Transaction, error)  
* func (t * Miner)ClearThawTx(height int64,ctx xctx.XContext)error  
* func (t *Miner) confirmBlockForMiner(ctx xctx.XContext, block *lpb.InternalBlock) error  
* func (t *Miner) trySyncBlock(ctx xctx.XContext, targetBlock *lpb.InternalBlock) error   
* func (t *Miner) syncBlock(ctx xctx.XContext, targetBlock *lpb.InternalBlock) error  
* func (t *Miner) downloadMissBlock(ctx xctx.XContext, targetBlock *lpb.InternalBlock)([][]byte, error)  
* func (t *Miner) getBlock(ctx xctx.XContext, blockId []byte) (*lpb.InternalBlock, error)   
* func (t *Miner) batchConfirmBlock(ctx xctx.XContext, blkIds [][]byte) error   
* func (t *Miner) isConfirmed(ctx xctx.XContext, bcs *xpb.ChainStatus) bool  
* func (t *Miner) broadcastBlock(ctx xctx.XContext, block *lpb.InternalBlock)   
* func (t *Miner) getWholeNetLongestBlock(ctx xctx.XContext) (*lpb.InternalBlock, error)   

**type BCSByHeight []*xpb.ChainStatus**  
* func (s BCSByHeight) Len() int   
* func (s BCSByHeight) Less(i, j int) bool  
* func (s BCSByHeight) Swap(i, j int)