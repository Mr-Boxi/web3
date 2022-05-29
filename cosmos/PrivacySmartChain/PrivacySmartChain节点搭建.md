# PrivachSmartChain节点搭建教程

## bootstrap 引导节点搭建

```bash
# 开启相关端口
ufw allow 26656  # 开放p2p端口
ufw allow 26657  # 开放rpc端口

# 创建存放sgx远程证明证书的目录
# 这个证书有因特尔签名的报告
mkdir -p /opt/privacy/.sgx_privacys

# 创建环境变量
# /usr/lib 下存放了三个重要的.so 动态库，与sgx相关
export PRIVACY_ENCLAVE_DIR=/usr/lib
export PRIVACY_SGX_STORAGE=/opt/privacy/.sgx_privacys

# 初始化enclava环境
# 这个命令会生成一个英特尔签名的远程证明证书
pscd init-enclave

# 检查是否有生成证书
ls -h /opt/privacy/.sgx_privacys/attestation_cert.der

# 设置链的id
pscd config chain-id pscdev
# 设置key模式
pscd config keyring-backend test
# 初始化链 banana 是节点别名，可以换
pscd init banana --chain-id pscdev
# 修改 app 中 gas 代币的名字
# 修改 创世文件中的代币名字
# stake -> upsc
# 需要自己修改

# 添加一个账号,助记词会打印在屏幕
pscd keys add a
# 备份助记词
echo "助记词" > a.txt

# 将 a 账号的信息写入创世块配置
pscd  add-genesis-account "$(pscd keys show -a a)"  1000000000000000000upsc

# 生成一笔交易： a 委托第一个验证器
# 注意要加上gas-prive
pscd gentx a 1000000upsc --chain-id pscdev --gas-prices 0.0125upsc

# 将这比交易收集进入genesis.json 中
pscd collect-gentxs
# 验证是genesis.json 是否有效
pscd validate-genesis

# 初始化引导节点
pscd init-bootstrap
pscd validate-genesis

# 创建一个logs文件夹
mkdir logs
# 后台运行
nohup pscd start --rpc.laddr tcp://0.0.0.0:26657 --bootstrap
# orlogs
nohup pscd start --rpc.laddr tcp://0.0.0.0:26657 --bootstrap >./logs/nohup.out 2>&1 & 
# 或者直接运行
pscd start --rpc.laddr tcp://0.0.0.0:26657 --bootstrap
```



## node 一般节点搭建

加入已有的网络

```bash
# ufw 开放防火墙
ufw allow 26656 #p2p
# 指向引导节点
secretd config node tcp://167.179.118.118:26657


nohup pscd start --rpc.laddr tcp://0.0.0.0:26657>./logs/nohup.out 2>&1 &
```

