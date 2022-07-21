# 账本组件实现
xuperleger  
交易池、状态机、账本  


### def 模块
相关的常量定义  
相关的错误定义
### config 配置模块

**type XLedgerConf struc**t  //账本配置
```
type XLedgerConf struct {
	// kv storage type
	KVEngineType string     `yaml:"kvEngineType,omitempty"`
	OtherPaths   []string   `yaml:"otherPaths,omitempty"`
	StorageType  string     `yaml:"storageType,omitempty"`
	Utxo         UtxoConfig `yaml:"utxo,omitempty"`
} 
```
**type UtxoConfig struct**  //utxo配置
```
type UtxoConfig struct {
	CacheSize      int `yaml:"cachesize,omitempty"`
	TmpLockSeconds int `yaml:"tmplockSeconds,omitempty"`
} 
```

func LoadLedgerConf(cfgFile string) (*XLedgerConf, error) //加载账本配置

---
### **ledger 账本模块  
账本组件的具体实现  

**type LedgerCtx struct**
``` 
// 账本运行上下文环境
type LedgerCtx struct {
	// 基础上下文
	xctx.BaseCtx
	// 运行环境配置
	EnvCfg *xconf.EnvConf
	// 账本配置
	LedgerCfg *lconf.XLedgerConf
	// 链名
	BCName string
}
```
- func NewLedgerCtx(envCfg *xconf.EnvConf, bcName string) (*LedgerCtx, error)

**type Ledger struct** // 账本结构体
```
// Ledger define data structure of Ledger
type Ledger struct {
	// 运行上下文
	ctx            *LedgerCtx
	baseDB         kvdb.Database // 底层是一个leveldb实例，kvdb进行了包装
	metaTable      kvdb.Database // 记录区块链的根节点、高度、末端节点
	confirmedTable kvdb.Database // 已确认的订单表
	blocksTable    kvdb.Database // 区块表
	mutex          *sync.RWMutex
	xlog           logs.Logger     //日志库
	meta           *pb.LedgerMeta  //账本关键的元数据{genesis, tip, height}
	GenesisBlock   *GenesisBlock   //创始块
	pendingTable   kvdb.Database   //保存临时的block区块
	heightTable    kvdb.Database   //保存高度到Blockid的映射
	blockCache     *cache.LRUCache // block cache, 加速QueryBlock
	blkHeaderCache *cache.LRUCache // block header cache, 加速fetchBlock
	cryptoClient   cryptoBase.CryptoClient
	confirmBatch   kvdb.Batch //新增区块
} 
```
- func newLedger(lctx *LedgerCtx, createIfMissing bool, genesisCfg []byte) (*Ledger, error)  
    创建账本
- func CreateLedger(lctx *LedgerCtx, genesisCfg []byte) (*Ledger, error) 
- func OpenLedger(lctx *LedgerCtx) (*Ledger, error)
- func (l *Ledger) Close()  
- func (l *Ledger) GetMeta() *pb.LedgerMeta  
- func (l *Ledger) GetLDB() kvdb.Database  
- func (l *Ledger) loadGenesisBlock(isEmptyLedger bool, genesisCfg []byte) error  
- func (l *Ledger) FormatRootBlock(txList []*pb.Transaction) (*pb.InternalBlock, error)   
- func (l *Ledger) FormatBlock(txList []*pb.Transaction,
  	proposer []byte, ecdsaPk *ecdsa.PrivateKey, /*矿工的公钥私钥*/
  	timestamp int64, curTerm int64, curBlockNum int64,
  	preHash []byte, utxoTotal *big.Int) (*pb.InternalBlock, error)
- func (l *Ledger) FormatMinerBlock(txList []*pb.Transaction,
  	proposer []byte, ecdsaPk *ecdsa.PrivateKey, /*矿工的公钥私钥*/
  	timestamp int64, curTerm int64, curBlockNum int64,
  	preHash []byte, targetBits int32, utxoTotal *big.Int,
  	qc *pb.QuorumCert, failedTxs map[string]string, blockHeight int64) (*pb.InternalBlock, error)  
- func (l *Ledger) FormatFakeBlock(txList []*pb.Transaction,
  	proposer []byte, ecdsaPk *ecdsa.PrivateKey, /*矿工的公钥私钥*/
  	timestamp int64, curTerm int64, curBlockNum int64,
  	preHash []byte, utxoTotal *big.Int, blockHeight int64) (*pb.InternalBlock, error)
- func (l *Ledger) formatBlock(txList []*pb.Transaction,
  	proposer []byte, ecdsaPk *ecdsa.PrivateKey, /*矿工的公钥私钥*/
  	timestamp int64, curTerm int64, curBlockNum int64,
  	preHash []byte, targetBits int32, utxoTotal *big.Int, needSign bool,
  	qc *pb.QuorumCert, failedTxs map[string]string, blockHeight int64) (*pb.InternalBlock, error) 
- func (l *Ledger) saveBlock(block *pb.InternalBlock, batchWrite kvdb.Batch) error
- func (l *Ledger) fetchBlock(blockid []byte) (*pb.InternalBlock, error)  
- func (l *Ledger) correctTxsBlockid(blockID []byte, batchWrite kvdb.Batch) error   
- func (l *Ledger) handleFork(oldTip []byte, newTipPre []byte, nextHash []byte, batchWrite kvdb.Batch) (*pb.InternalBlock, error)  
- func (l *Ledger) IsValidTx(idx int, tx *pb.Transaction, block *pb.InternalBlock) bool  
- func (l *Ledger) UpdateBlockChainData(txid string, ptxid string, publickey string, sign string, height int64) error  
- func (l *Ledger) parallelCheckTx(txs []*pb.Transaction, block *pb.InternalBlock) (map[string]bool, map[string][]byte)  
- func (l *Ledger) ConfirmBlock(block *pb.InternalBlock, isRoot bool) ConfirmStatus  
- func (l *Ledger) ExistBlock(blockid []byte) bool  
- func (l *Ledger) queryBlock(blockid []byte, needBody bool) (*pb.InternalBlock, error)   

余额管理    
- func (l *Ledger) updateBranchInfo(addedBlockid, deletedBlockid []byte, addedBlockHeight int64, batch kvdb.Batch) error
- func (l *Ledger) GetBranchInfo(targetBlockid []byte, targetBlockHeight int64) ([]string, error)
- func (l *Ledger) HandleFork(oldTip []byte, newTip []byte, batchWrite kvdb.Batch) (*pb.InternalBlock, error)
- func (l *Ledger) GetCommonParentBlockid(branch1Blockid, branch2Blockid []byte) ([]byte, error)  
- func (l *Ledger) SetMeta(meta *pb.LedgerMeta)  
- func (l *Ledger) RemoveBlocks(fromBlockid []byte, toBlockid []byte, batch kvdb.Batch) error  

**type ConfirmStatus struct**
``` 
// ConfirmStatus block status
type ConfirmStatus struct {
	Succ        bool  // 区块是否提交成功
	Split       bool  // 提交后是否发生了分叉
	Orphan      bool  // 是否是个孤儿节点
	TrunkSwitch bool  // 是否导致了主干分支切换
	Error       error //错误消息
}
```

**type GenesisBlock struct**  //创世块
``` 
type GenesisBlock struct {
  	config     *RootConfig
  	awardCache *cache.LRUCache
}
```
- func NewGenesisBlock(genesisCfg []byte) (*GenesisBlock, error)  
- func (gb *GenesisBlock) GetConfig() *RootConfig  
- func (gb *GenesisBlock) CalcAward(blockHeight int64) *big.Int  


**type RootConfig struct** //创世块配置
```
type RootConfig struct {
	Version   string `json:"version"`
	Crypto    string `json:"crypto"`
	Kvengine  string `json:"kvengine"`
	Consensus struct {
		Type  string `json:"type"`
		Miner string `json:"miner"`
	} `json:"consensus"`
	Predistribution []struct {
		Address string `json:"address"`
		Quota   string `json:"quota"`
	}
	// max block size in MB
	MaxBlockSize string `json:"maxblocksize"`
	Period       string `json:"period"`
	NoFee        bool   `json:"nofee"`
	Award        string `json:"award"`
	AwardDecay   struct {
		HeightGap int64   `json:"height_gap"`
		Ratio     float64 `json:"ratio"`
	} `json:"award_decay"`
	GasPrice struct {
		CpuRate  int64 `json:"cpu_rate"`
		MemRate  int64 `json:"mem_rate"`
		DiskRate int64 `json:"disk_rate"`
		XfeeRate int64 `json:"xfee_rate"`
	} `json:"gas_price"`
	Decimals          string                 `json:"decimals"`
	GenesisConsensus  map[string]interface{} `json:"genesis_consensus"`
	ReservedContracts []InvokeRequest        `json:"reserved_contracts"`
	ReservedWhitelist struct {
		Account string `json:"account"`
	} `json:"reserved_whitelist"`
	ForbiddenContract InvokeRequest `json:"forbidden_contract"`
	// NewAccountResourceAmount the amount of creating a new contract account
	NewAccountResourceAmount int64 `json:"new_account_resource_amount"`
	// IrreversibleSlideWindow
	IrreversibleSlideWindow string `json:"irreversibleslidewindow"`
	// GroupChainContract
	GroupChainContract InvokeRequest `json:"group_chain_contract"`
} 
```
- func (rc *RootConfig) GetCryptoType() string 
- func (rc *RootConfig) GetIrreversibleSlideWindow() int64
- func (rc *RootConfig) GetMaxBlockSizeInByte() (n int64)
- func (rc *RootConfig) GetNewAccountResourceAmount() int64   
- func (rc *RootConfig) GetGenesisConsensus() (map[string]interface{}, error)  
- func (rc *RootConfig) GetReservedContract() ([]*protos.InvokeRequest, error)   
- func (rc *RootConfig) GetForbiddenContract() ([]*protos.InvokeRequest, error)   
- func (rc *RootConfig) GetGroupChainContract() ([]*protos.InvokeRequest, error)   
- func (rc *RootConfig) GetReservedWhitelistAccount() string   
- 

函数：  
func getLeafSize(txCount int) int  
func merkleDoubleSha256(left, right, result []byte) []byte   
func arenaAllocator(elemSize, elemNumer int) func() []byte  
func MakeMerkleTree(txList []*pb.Transaction) [][]byte   
func encodeFailedTxs(buf *bytes.Buffer, block *pb.InternalBlock) error   
func encodeJustify(buf *bytes.Buffer, block *pb.InternalBlock) error  
func VerifyMerkle(block *pb.InternalBlock) error   
func MakeBlockID(block *pb.InternalBlock) ([]byte, error)  

---
### **状态机模块  
状态机实现   

状态机运行上下文   
utxo  
xmodel  
state

**type StateCtx struct**
```
// 状态机运行上下文环境
type StateCtx struct {
	// 基础上下文
	xctx.BaseCtx
	// 运行环境配置
	EnvCfg *xconf.EnvConf
	// 账本配置
	LedgerCfg *lconf.XLedgerConf
	// 链名
	BCName string
	// ledger handle
	Ledger *ledger.Ledger
	// crypto client
	Crypt cryptoBase.CryptoClient
	// acl manager
	// 注意：注入后才可以使用
	AclMgr aclBase.AclManager
	// contract Manager
	// 注意：依赖注入后才可以使用
	ContractMgr contract.Manager
	// 注意：注入后才可以使用
	GovernTokenMgr governToken.GovManager
	// 注意：注入后才可以使用
	ProposalMgr propose.ProposeManager
	// 注意：注入后才可以使用
	TimerTaskMgr timerTask.TimerManager
} 
```
- func NewStateCtx(envCfg *xconf.EnvConf, bcName string, leg *ledger.Ledger, crypt cryptoBase.CryptoClient) (*StateCtx, error)
- func (t *StateCtx) SetAclMG(aclMgr aclBase.AclManager)
- func (t *StateCtx) SetContractMG(contractMgr contract.Manager)  
- func (t *StateCtx) SetGovernTokenMG(governTokenMgr governToken.GovManager) 
- func (t *StateCtx) SetProposalMG(proposalMgr propose.ProposeManager) 
- func (t *StateCtx) SetTimerTaskMG(timerTaskMgr timerTask.TimerManager)  
- func (t *StateCtx) IsInit() bool  


**type Meta struct**
```
 type Meta struct {
 	log       logs.Logger
 	Ledger    *ledger.Ledger
 	Meta      *pb.UtxoMeta  // utxo meta
 	MetaTmp   *pb.UtxoMeta  // tmp utxo meta
 	MutexMeta *sync.Mutex   // access control for meta
 	MetaTable kvdb.Database // 元数据表，会持久化保存latestBlockid
 }
```
- func NewMeta(sctx *context.StateCtx, stateDB kvdb.Database) (*Meta, error)
- func (t *Meta) GetNewAccountResourceAmount() int64
- func (t *Meta) LoadNewAccountResourceAmount() (int64, error) 
- func (t *Meta) UpdateNewAccountResourceAmount(newAccountResourceAmount int64, batch kvdb.Batch) error 
- func (t *Meta) GetMaxBlockSize() int64 
- func (t *Meta) LoadMaxBlockSize() (int64, error) 
- func (t *Meta) MaxTxSizePerBlock() (int, error) 
- func (t *Meta) UpdateMaxBlockSize(maxBlockSize int64, batch kvdb.Batch) error 
- func (t *Meta) GetReservedContracts() []*protos.InvokeRequest 
- 
-
- 

**type UtxoVM struct**
``` 
type UtxoVM struct {
	metaHandle        *meta.Meta
	ldb               kvdb.Database
	Mutex             *sync.RWMutex // utxo leveldb表读写锁
	MutexMem          *sync.Mutex   // 内存锁定状态互斥锁
	SpLock            *SpinLock     // 自旋锁,根据交易涉及的utxo和改写的变量
	mutexBalance      *sync.Mutex   // 余额Cache锁
	lockKeys          map[string]*UtxoLockItem
	lockKeyList       *list.List // 按锁定的先后顺序，方便过期清理
	lockExpireTime    int        // 临时锁定的最长时间
	UtxoCache         *UtxoCache
	log               logs.Logger
	ledger            *ledger.Ledger           // 引用的账本对象
	utxoTable         kvdb.Database            // utxo表
	OfflineTxChan     chan []*pb.Transaction   // 未确认tx的通知chan
	PrevFoundKeyCache *cache.LRUCache          // 上一次找到的可用utxo key，用于加速GenerateTx
	utxoTotal         *big.Int                 // 总资产
	cryptoClient      crypto_base.CryptoClient // 加密实例
	ModifyBlockAddr   string                   // 可修改区块链的监管地址
	BalanceCache      *cache.LRUCache          //余额cache,加速GetBalance查询
	CacheSize         int                      //记录构造utxo时传入的cachesize
	BalanceViewDirty  map[string]int           //balanceCache 标记dirty: addr -> sequence of view
	unconfirmTxInMem  *sync.Map                //未确认Tx表的内存镜像
	unconfirmTxAmount int64                    // 未确认的Tx数目，用于监控
	bcname            string
}
```
- func NewUtxo(sctx *context.StateCtx, metaHandle *meta.Meta, stateDB kvdb.Database) (*UtxoVM, error)
- 

**type UtxoCache struct**
```
 // UtxoCache is a in-memory cache of UTXO
 type UtxoCache struct {
 	// <ADDRESS, <UTXO_KEY, UTXO_ITEM>>
 	Available map[string]map[string]*CacheItem
 	All       map[string]map[string]*CacheItem
 	List      *list.List
 	Limit     int
 	mutex     *sync.Mutex
 }
```

**type UtxoItem struct**   
```
 // UtxoItem the data structure of an UTXO item
 type UtxoItem struct {
 	Amount       *big.Int //utxo的面值
 	FrozenHeight int64    //锁定until账本高度超过
 }

```
- func (item *UtxoItem) Loads(data []byte) error 
- func (item *UtxoItem) Dumps() ([]byte, error)

**type UTXOSandbox struct**
```
type UTXOSandbox struct {
	inputCache  []*protos.TxInput
	outputCache []*protos.TxOutput
	utxoReader  contract.UtxoReader
} 
```
- func NewUTXOSandbox(cfg *contract.SandboxConfig) *UTXOSandbox 
- func (u *UTXOSandbox) Transfer(from, to string, amount *big.Int) error 
- func (uc *UTXOSandbox) GetUTXORWSets() *contract.UTXORWSet 

---
xumodel 模型

**type XModel struct**
```
// XModel xmodel data structure
type XModel struct {
	ledger          *ledger.Ledger
	stateDB         kvdb.Database
	unconfirmTable  kvdb.Database
	extUtxoTable    kvdb.Database
	extUtxoDelTable kvdb.Database
	logger          logs.Logger
	batchCache      *sync.Map
	lastBatch       kvdb.Batch
	// extUtxoCache caches per bucket key-values using version as key
	extUtxoCache sync.Map // map[string]*LRUCache
} 
```

state 状态机

**type State struct**
```
 type State struct {
 	// 状态机运行环境上下文
 	sctx          *context.StateCtx
 	log           logs.Logger
 	utxo          *utxo.UtxoVM   //utxo表
 	xmodel        *xmodel.XModel //xmodel数据表和历史表
 	meta          *meta.Meta     //meta表
 	tx            *tx.Tx         //未确认交易表
 	ldb           kvdb.Database
 	latestBlockid []byte
 
 	// 最新区块高度通知装置
 	heightNotifier *BlockHeightNotifier
 }
```
- func NewState(sctx *context.StateCtx) (*State, error) //创建状态机实例  
- func (t *State) SetAclMG(aclMgr aclBase.AclManager) 
- func (t *State) SetContractMG(contractMgr contract.Manager)
- func (t *State) SetGovernTokenMG(governTokenMgr governToken.GovManager)  
- func (t *State) SetProposalMG(proposalMgr propose.ProposeManager)  
- func (t *State) SetTimerTaskMG(timerTaskMgr timerTask.TimerManager)
 
- func (t *State) SelectUtxos(fromAddr string, totalNeed *big.Int, needLock, excludeUnconfirmed bool) ([]*protos.TxInput, [][]byte, *big.Int, error)
-  

**type BlockAgent struct**
``` 
type BlockAgent struct {
	blk *lpb.InternalBlock
}
```
**type BlockHeightNotifier struct**
```
type BlockHeightNotifier struct {
	mutex  sync.Mutex
	cond   *sync.Cond
	height int64
} 
```



对外接口  
NewLedgerCtx()  
NewState()

RegisterAclMG(t.ctx.Acl)  
RegisterContractMG(t.ctx.Contract)

---
### *交易模块

**type Tx struct** 
``` 
type Tx struct {
	log               logs.Logger
	ldb               kvdb.Database
	unconfirmedTable  kvdb.Database
	UnconfirmTxAmount int64
	UnconfirmTxInMem  *sync.Map
	AvgDelay          int64
	ledger            *ledger.Ledger
	maxConfirmedDelay uint32
}
```

---
### *xldgpb 模块

type InternalBlock struct
```
// The internal block struct
type InternalBlock struct {
	// block version
	Version int32 `protobuf:"varint,1,opt,name=version,proto3" json:"version,omitempty"`
	// Random number used to avoid replay attacks
	Nonce int32 `protobuf:"varint,2,opt,name=nonce,proto3" json:"nonce,omitempty"`
	// blockid generate the hash sign of the block used by sha256
	Blockid []byte `protobuf:"bytes,3,opt,name=blockid,proto3" json:"blockid,omitempty"`
	// pre_hash is the parent blockid of the block
	PreHash []byte `protobuf:"bytes,4,opt,name=pre_hash,json=preHash,proto3" json:"pre_hash,omitempty"`
	// The miner id
	Proposer []byte `protobuf:"bytes,5,opt,name=proposer,proto3" json:"proposer,omitempty"`
	// The sign which miner signed: blockid + nonce + timestamp
	Sign []byte `protobuf:"bytes,6,opt,name=sign,proto3" json:"sign,omitempty"`
	// The pk of the miner
	Pubkey []byte `protobuf:"bytes,7,opt,name=pubkey,proto3" json:"pubkey,omitempty"`
	// The Merkle Tree root
	MerkleRoot []byte `protobuf:"bytes,8,opt,name=merkle_root,json=merkleRoot,proto3" json:"merkle_root,omitempty"`
	// The height of the blockchain
	Height int64 `protobuf:"varint,9,opt,name=height,proto3" json:"height,omitempty"`
	// Timestamp of the block
	Timestamp int64 `protobuf:"varint,10,opt,name=timestamp,proto3" json:"timestamp,omitempty"`
	// Transactions of the block, only txid stored on kv, the detail information
	// stored in another table
	Transactions []*Transaction `protobuf:"bytes,11,rep,name=transactions,proto3" json:"transactions,omitempty"`
	// The transaction count of the block
	TxCount int32 `protobuf:"varint,12,opt,name=tx_count,json=txCount,proto3" json:"tx_count,omitempty"`
	// 所有交易hash的merkle tree
	MerkleTree  [][]byte          `protobuf:"bytes,13,rep,name=merkle_tree,json=merkleTree,proto3" json:"merkle_tree,omitempty"`
	CurTerm     int64             `protobuf:"varint,16,opt,name=curTerm,proto3" json:"curTerm,omitempty"`
	CurBlockNum int64             `protobuf:"varint,17,opt,name=curBlockNum,proto3" json:"curBlockNum,omitempty"`
	FailedTxs   map[string]string `protobuf:"bytes,18,rep,name=failed_txs,json=failedTxs,proto3" json:"failed_txs,omitempty" protobuf_key:"bytes,1,opt,name=key,proto3" protobuf_val:"bytes,2,opt,name=value,proto3"`
	TargetBits  int32             `protobuf:"varint,19,opt,name=targetBits,proto3" json:"targetBits,omitempty"`
	// Justify used in chained-bft
	Justify *QuorumCert `protobuf:"bytes,20,opt,name=Justify,proto3" json:"Justify,omitempty"`
	// 下面的属性会动态变化
	// If the block is on the trunk
	InTrunk bool `protobuf:"varint,14,opt,name=in_trunk,json=inTrunk,proto3" json:"in_trunk,omitempty"`
	// Next next block which on trunk
	NextHash             []byte   `protobuf:"bytes,15,opt,name=next_hash,json=nextHash,proto3" json:"next_hash,omitempty"`
	XXX_NoUnkeyedLiteral struct{} `json:"-"`
	XXX_unrecognized     []byte   `json:"-"`
	XXX_sizecache        int32    `json:"-"`
} 
``` 





