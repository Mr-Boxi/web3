### tdpos 共识实现  

- tdpos 共识算法  
    
- struct  
    **type tdposConsensus struct** // 实现共识框架ConsensusImplInterface接口  
    
    * func (tp *tdposConsensus) CompeteMaster(height int64) (bool, bool, error)  
    * func (tp *tdposConsensus) CalculateBlock(block cctx.BlockInterface) error  
    * func (tp *tdposConsensus) CheckMinerMatch(ctx xcontext.XContext, block cctx.BlockInterface) (bool, error)  
    * func (tp *tdposConsensus) ProcessBeforeMiner(timestamp int64) ([]byte, []byte, error)  
    * func (tp *tdposConsensus) renewQCStatus(tipBlock cctx.BlockInterface) (bool, []byte, error)  
    * func (tp *tdposConsensus) ProcessConfirmBlock(block cctx.BlockInterface) error  
    * func (tp *tdposConsensus) Stop() error  
    * func (tp *tdposConsensus) Start() error  
    * func (tp *tdposConsensus) ParseConsensusStorage(block cctx.BlockInterface) (interface{}, error)  
    * func (tp *tdposConsensus) GetConsensusStatus() (base.ConsensusStatus, error)  
    * func (tp *tdposConsensus) GetJustifySigns(block cctx.BlockInterface) []*chainedBftPb.QuorumCertSign  
    
    * func (tp *tdposConsensus) runNominateCandidate(contractCtx contract.KContext) (*contract.Response, error)  
    * func (tp *tdposConsensus) runRevokeCandidate(contractCtx contract.KContext) (*contract.Response, error)  
    * func (tp *tdposConsensus) runVote(contractCtx contract.KContext) (*contract.Response, error)  
    * func (tp *tdposConsensus) runRevokeVote(contractCtx contract.KContext) (*contract.Response, error)  
    * func (tp *tdposConsensus) checkArgs(txArgs map[string][]byte) (string, int64, error)  
    * func (tp *tdposConsensus) isAuthAddress(candidate string, initiator string, authRequire []string) bool  
    * func (tp *tdposConsensus) needSync() bool
       
    **type TdposStatus struct**   // 实现了ConsensusStatus接  
    
    * func (t *TdposStatus) GetVersion() int64  
    * func (t *TdposStatus) GetConsensusBeginInfo()  
    * func (t *TdposStatus) GetStepConsensusIndex() int  
    * func (t *TdposStatus) GetConsensusName() string  
    * func (t *TdposStatus) GetCurrentTerm() int64
    * func (t *TdposStatus) GetCurrentValidatorsInfo() []byte
    * func (t *TdposStatus) getTdposInfos() string
    
    **type tdposSchedule struct** // 实现了ProposerElectionInterface接口  
    
    * func (s *tdposSchedule) minerScheduling(timestamp int64) (term int64, pos int64, blockPos int64) 
    * func (s *tdposSchedule) getSnapshotKey(height int64, bucket string, key []byte) ([]byte, error)  
    * func (s *tdposSchedule) GetLeader(round int64) string  
    * func (s *tdposSchedule) calAddTime(round int64, tipHeight int64) int64  
    * func (s *tdposSchedule) GetValidators(round int64) []string  
    * func (s *tdposSchedule) GetIntAddress(address string) string  
    * func (s *tdposSchedule) UpdateProposers(height int64) bool  
    * func (s *tdposSchedule) CalculateProposers(height int64) ([]string, error)  
    * func (s *tdposSchedule) calTopKNominator(height int64) ([]string, error)  
    * func (s *tdposSchedule) CalOldProposers(height int64, timestamp int64, storage []byte) ([]string, error)
    * func (s *tdposSchedule) calHisValidators(height int64) ([]string, error)  
    * func (s *tdposSchedule) binarySearch(begin int64, end int64, term int64) (int64, error)
    * func (s *tdposSchedule) getTerm(pos int64) (int64, error)  
    
    type tdposConfig struct  
    
    * func unmarshalTdposConfig(input []byte) (*tdposConfig, error)  
    
    type termBallotsSlice []*termBallots  
    
    * func (tv termBallotsSlice) Len() int  
    * func (tv termBallotsSlice) Swap(i, j int)  
    * func (tv termBallotsSlice) Less(i, j int) bool 
    
    type nominateValue map[string]map[string]int64  
        
    type voteValue map[string]int64  
        
    type revokeValue map[string][]revokeItem  
        
    type revokeItem struct
        

- func
    
    * func NewTdposConsensus(cCtx cctx.ConsensusCtx, cCfg def.ConsensusConfig) base.ConsensusImplInterface 
    * func NewSchedule(xconfig *tdposConfig, log logs.Logger, ledger cctx.LedgerRely, startHeight int64) *tdposSchedule  
    * func ParseConsensusStorage(block cctx.BlockInterface) (interface{}, error)  
    * func buildConfigs(input []byte) (*tdposConfig, error) 