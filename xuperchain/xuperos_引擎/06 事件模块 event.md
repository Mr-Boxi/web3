## 事件模块 event
分发过滤事件  

目录
- block_iterator.go  
    定义区块迭代器结构体
    * type BlockIterator struct // 继承区块存储接口
    
- block_store.go  
   定义链管理接口，获取区块存储接口 
   
   定义区块接口
   
   定义区块存储结构体，继承账本和状态机接口
   * type ChainManager interface 
   * type chainManager struct  // 继承引擎接口
   
   * type BlockStore interface
   * type blockStore struct
   
   
- block_topic.go  
    定义区块分类结构体
    
   * type BlockTopic struct  // 继承链管理接口,如上
   
- filtered_block_iterator.go  
    定义过滤区块迭代器 结构体 
    * type filteredBlockIterator struct 
    
- filters.go  
    定义区块过滤器 结构体
   * type blockFilter struct
   
- **router.go**  
    定义事件分发结构体，又称路由
    * type Router struct
    
- topic.go  
    定义迭代器接口  
    事件分类器接口
    * type Topic interface 
    * type Iterator interface 
