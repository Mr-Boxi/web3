## asyncwoker模块  
xuperos/asyncwoker  
异步任务模块  结合公共模块接口阅读

目录：  
- asyncworker_impl.go  
    定义异步任务结构体
    * type AsyncWorkerImpl struct
- context.go  
    定义任务上下文结构体
    * type TaskContextImpl struct
- interface.go  
    定义异步任务接口
    * type AsyncWorker interface

### 结构体如下      
**type AsyncWorker interface**  
```
type AsyncWorker interface {
    RegisterHandler(contract string, event string, handler func(ctx common.TaskContext) error)
}
```
* RegisterHandler(contract string, event string, handler func(ctx common.TaskContext) error)  
    
**type AsyncWorkerImpl struct** 
```
type AsyncWorkerImpl struct {
    bcname  string
    mutex   sync.Mutex
    methods map[string]map[string]common.TaskHandler // 句柄存储

    filter      *protos.BlockFilter // 订阅event事件时的筛选正则
    router      *event.Router       // 通过router进行事件订阅
    finishTable kvdb.Database       //保存临时的block区块

    close chan struct{}

    log logs.Logger
}
``` 
* func NewAsyncWorkerImpl(bcName string, e common.Engine, baseDB kvdb.Database) (*AsyncWorkerImpl, error)  
* func (aw *AsyncWorkerImpl) RegisterHandler(contract string, event string, handler common.TaskHandler)   
* func (aw *AsyncWorkerImpl) addBlockFilter(contract, event string)   
* func (aw *AsyncWorkerImpl) Start() (err error)   
* func (aw *AsyncWorkerImpl) doAsyncTasks(txs []*protos.FilteredTransaction, height int64, cursor *asyncWorkerCursor) error  
* func (aw *AsyncWorkerImpl) storeCursor(cursor asyncWorkerCursor) error  
* func (aw *AsyncWorkerImpl) reloadCursor() (*asyncWorkerCursor, error)   
* func (aw *AsyncWorkerImpl) getAsyncTask(contract, event string) (common.TaskHandler, error)  
* func (aw *AsyncWorkerImpl) Stop()  

**type asyncWorkerCursor struct**  //消费器

**type TaskContextImpl struct**  //任务上下文接口实现
```
type TaskContextImpl struct {
    decodeFunc func(data []byte, v interface{}) error
    buf        []byte
} 
```
* func newTaskContextImpl(buf []byte) *TaskContextImpl  
* func (tc *TaskContextImpl) ParseArgs(v interface{}) error  
* func (tc *TaskContextImpl) RetryTimes() int  