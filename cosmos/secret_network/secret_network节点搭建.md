# 节点搭建

##  环境设置

所有节点都需要进行配置

BIOS设置：https://zhuanlan.zhihu.com/p/465275437

1. BIOS主要关闭hyper thread 和 turbo mode
2. 安装sgx环境

```bash
wget https://raw.githubusercontent.com/SecretFoundation/docs/main/docs/node-guides/sgx
chmod +x sgx
bash sgx
```

3. 验证sgx环境


```bash
# 下载  deb  1.3.0
wget https://github.com/scrtlabs/SecretNetwork/releases/download/v1.3.0/secretnetwork_1.3.0_mainnet_goleveldb_amd64.deb
# 安装deb包,"/usr/bin/..."
dpkg -i secretnetwork_1.3.0_mainnet_goleveldb_amd64.deb 
# 查看版本 
secretd version
```

```bash
# 验证
secretd init-enclave # 在/opt/secret/.sgx_secret 下创建远程证明文件
```

## bootstrap 引导节点搭建

搭建一个新的网络，需要引导节点。搭建过程如下：

```bash
#  防火墙
ufw allow 26656  # 开放p2p端口
ufw allow 26657  # 开放rpc端口

# 清理一些数据
rm -rf ~/.secretd/*
rm -rf /opt/secret/.sgx_secrets/*

# 设置链的id
secretd config chain-id secretdev-1
# 设置key 模式
secretd config keyring-backend test
# 初始化链， banana 是节点别名，可以换
secretd init banana --chain-id secretdev-1
# 使用uscrt 换掉 stake  (代币名字)
perl -i -pe 's/"stake"/ "uscrt"/g' ~/.secretd/config/genesis.json
# 添加一个账号
secretd keys add a
# 将账号写入创世配置，初始化金额
secretd add-genesis-account "$(secretd keys show -a a)" 1000000000000000000uscrt
# a 账号给节点 1000000uscrt
secretd gentx a 1000000uscrt --chain-id secretdev-1
# 写入创世文件中
secretd collect-gentxs
secretd validate-genesis
# 初始化引导节点
secretd init-bootstrap
secretd validate-genesis
# 创建一个logs文件夹
mkdir logs
# 运行引导节点,后台运行
nohup secretd start --rpc.laddr tcp://0.0.0.0:26657 --bootstrap >./logs/nohup.out 2>&1 & 

# p2p持久化的地址
secretd tendermint show-node-id
# a08755b76ba89c542e62ec0f35c06bd8c6a9c73c
```

## node 节点加入网络

运行节点加入网络

```bash
# ufw 开放防火墙
ufw allow 26656 #p2p
# 指向引导节点
secretd config node tcp://167.179.118.118:26657
# 设置链名
secretd config chain-id secretdev-1
# 初始胡链信息， hostname 自己取
secretd init $hostname --chain-id secretdev-1
# 引导节点的p2p种子 “secretd tendermint show-node-id”
PERSISTENT_PEERS="a08755b76ba89c542e62ec0f35c06bd8c6a9c73c@167.179.118.118:26656"
# 持久化种子
sed -i 's/persistent_peers = ""/persistent_peers = "'$PERSISTENT_PEERS'"/g' ~/.secretd/config/config.toml
echo "Set persistent_peers: $PERSISTENT_PEERS"
# 创建dafni账号
secretd keys add dafni
# 引导节点给dafni 转账
secretd tx bank send secret1jvtdv8674llygwn8s0d7z47uctyjf9uxu9p8k4 secret17tuk77p0eqs8nqevwhqs9lrsqm54e56uef6rey 100000uscrt
# 校验公钥

# 注册
secretd tx register auth /opt/secret/.sgx_secrets/attestation_cert.der -y --from dafni --gas-prices 0.25uscrt
# 拿到种子
SEED=$(secretd q register seed "$PUBLIC_KEY" 2> /dev/null | cut -c 3-)
echo "SEED: $SEED"
# 设置一些参数
secretd q register secret-network-params 2> /dev/null

secretd configure-secret node-master-cert.der "$SEED"
# 复制创世文件
下载创世文件，替换
# 校验
secretd validate-genesis

secretd config node tcp://localhost:26657
# 运行
nohup secretd start >./logs/nohup.out 2>&1 & 
```

## node 成为验证人

```bash
# 你的地址<key-alias>需要有钱
# 没有的话，使用bootstrap的地址转
# --identity= --moniker=<MONIKER> --from=<key-alias> 填入自己的
secretcli tx staking create-validator \
  --amount=100000000uscrt \
  --pubkey=$(secretd tendermint show-validator) \
  --identity={KEYBASE_IDENTITY} \
  --details="To infinity and beyond!" \
  --commission-rate="0.10" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1" \
  --moniker=<MONIKER> \
  --from=<key-alias>
```

```bash
# 查询
# moniker 修改你的
secretcli q staking validators | grep moniker
```



