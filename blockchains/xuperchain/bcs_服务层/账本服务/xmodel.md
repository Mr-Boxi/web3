# xmodel 存储模型
目录:
- xmodel 结构体
- 

### XModel结构体
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
```
type XMIterator struct {
	bucket string
	iter   kvdb.Iterator
	model  *XModel
	value  *kledger.VersionedData
	err    error
}
```

```
type xModSnapshot struct {
	xmod      *XModel
	logger    logs.Logger
	blkHeight int64
	blkId     []byte
}
```
```
type xMSnapshotReader struct {
	xMReader kledger.XMReader
} 
```