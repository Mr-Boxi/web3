分别从cosmwasm合约的三个入口点阅读一个合约。

## erc20 前置知识

...

## 实例化 (Instantiate)

### InstantiateMsg

```rust
// 实例化的相关消息
#[derive(Serialize, Deserialize, JsonSchema)]
pub struct InstantiateMsg{
    // 代币名字
    pub name: String,
    // 代币符号
    pub symbol: String,
    // 精度
    pub decimals: u8,
    // 初始化账号的余额,可能有多个账号用数组存放起来
    pub initial_balances: Vec<InitialBalance>,
}

#[derive(Serialize, Deserialize, Clone, PartialEq, JsonSchema)]
pub struct InitialBalance {
    // 地址
    pub address: String,
    // 代币数量
    pub amount: Uint128,
}
```

### instantiate 函数逻辑

```rust
// contract.rs
fn instantiate(
	deps: DepsMut,
    _env: Env,
    _info: MessageInfo,
    msg: InstantiateMsg,
) -> Result<Response, ContractError>{
    // 总发行量
    let mut total_supply: u128 = 0;
    {
        // 初始化余额
        let mut balance_store = PrefixedStorage::new(deps.storage, PREFIX_BALANCES);
        for row in msg.initial_balances {
            let amount_raw = row.amount.u128();
            balance_store.set(row.address.as_str().as_bytes(),&amount_raw.to_be_bytes());
            total_supply += amount_raw;
        }
    }
    
   // 检查 name, symbol, decimals
    if !is_valid_name(&msg.name){
        return Err(ContractError::NameWrongFormat {});
    }
    if !is_valid_symbol(&msg.symbol){
        return Err(ContractError::TickerWrongSymbolFormat {});
    }
    if is_msg.decimals > 18 {
       return Err(ContractError::DecimalsExceeded {}); 
    }
    
    // 存储状态
    let mut config_store = PrefixedStorage::new(deps.storage, PREFIX_CONFIG);
    let constants = to_vec(&Constants {
        name: msg.name,
        symbol: msg.symbol,
        decimals: msg.decimals,
    })?;
    config_store.set(KEY_CONSTANTS, &constants);
    config_store.set(KEY_TOTAL_SUPPLY, &total_supply.to_be_bytes());
    
    Ok(Response::default())
}
```

## 执行 (Execute)

### ExecuteMsg

```rust
#[derive(Serialize, Deserialize, JsonSchema)]
#[serde(rename_all = "snake_case")]
pub enum ExecuteMsg{
    Approve {
        spender: String,
        amount: Uint128,
    },
    Transfer{
        recipient: String,
        amount: Uint128,
    },
    TransferFrom {
        owner: String,
        recipient: String,
        amount: Uint128,
    },
    Burn {
        amount: Uint128,
    }
}
```

### execute 逻辑

```rust
#[entry_point]
pub fn execute(
	deps: DepsMut,
    env: Env,
    info: MessageInfo,
    msg: ExecuteMsg,
) -> Result<Response, ContractError> {
    match msg {
        ExecuteMsg::Approve{spender, amount} => ,
        ExecuteMsg::Transfer{recipient, amount} => ,
        ExecuteMsg::TransferFrom{owner, recipient, amount} => ,
        ExecuteMsg::Burn{amount} => ,
    }
}

// 授权
fn try_approve(
    deps: DepsMut,
    _env: Env,
    info: MessageInfo,
    spender: String,
    amount: &Uint128,
) -> Result<Response, ContractError>{
    let spender_address = deps.api.addr_validate(spender.as_str())?;
    write_allowance(deps.storage, &info.sender, &spender_address, amount_u128())?;
    Ok(Response::new()
    	.add_attribute("action", "approve")
        .add_attribute("owner", info.sender)
        .add_attribut("spender", spender))
}

// 转账
fn try_transfer(
    deps: DepsMut,
    _env: Env,
    info: MessageInfo,
    recipient: String,
    amount: &Uint128,
)-> Result<Response, ContractError>{
    perform_transfer(
    	deps.storage,
        &info.sender,
        &deps.api.addr_validate(recipient,as_str())?,
        amount.u128(),
    )?;
    Ok(Response::new()
    	.add_attribute("action", "transfer")
    	.add_attribute("sender",info.sender)
    	.add_attribute("recipient",recipient))
}

// 转账
fn try_transfer_from(
    deps: DepsMut,
    _env: Env,
    info: MessageInfo,
    owner: String,
    recipient: String,
    amount: &Uint128,
) -> Result<Response, ContractError> {
    // 发送者地址
    let owner_address = deps.api.addr_validate(owner.as_str())?;
    // 接受者地址
    let recipient_address = deps.api.addr_validate(recipient.as_str())?;
    let amount_raw = amount.u128();
    // 检查金额是否足够
    let mut allowance = read_allowance(deps.storage, &owner_address, &info.sender)?;
    if allowance < amount_raw {
        return Err(ContractError::InsufficientAllowance {
            allowance,
            required: amount_raw,
        });
    }
    
    // 更改状态
    allowance -= amount_raw;
    write_allowance(deps.storage, &owner_address, &info.sender, allowance)?;
    perform_transfer(deps.storage, &owner_address, &recipient_address, amount_raw)?;
    
    Ok(Response::new()
        .add_attribute("action", "transfer_from")
        .add_attribute("spender", &info.sender)
        .add_attribute("sender", owner)
        .add_attribute("recipient", recipient))
} 

// 销毁
fn try_burn(
    deps: DepsMut,
    _env: Env,
    info: MessageInfo,
    amount: &Uint128,
)-> Result<Response, ContractError> {
    
}

// 转账逻辑
fn perform_transfer(

) -> Result<(), ContractError> {
    
}
```



## 查询(Query)

### QueryMsg

```rust
#[derive(Serialize, Deserialize, Clone, Debug, PartialEq, JsonSchema)]
#[serde(rename_all = "snake_case")]
pub enum QueryMsg {
    // 余额信息
    Balance {address: String},
    // 授权情况 
    Allowance {owner: String, spender: String},
}
```

### query 逻辑

```rust
#[entry_point]
pub fn query(deps: Deps, _env: Env, msg: QueryMsg) -> Result<Binary, ContractError>{
    match msg {
        QueryMsg::Balance {address} => {
            let address_key = deps.api.addr_validate(&address)?;
            let balance = read_balance(deps.storage, &address_key)?;
            let out = to_binary(&BalanceResponse {
                balance: Uint128::from(balance),
            })?;
            Ok(out)
        }
        QueryMsg::Allowance { owner, spender} => {
            let owner_key = deps.api.addr_validate(&owner)?;
            let spender_key = deps.api.addr_validate(&spender)?;
            let allowance = read_allowance(deps.storage, &owner_key, &spender_key)?;
            let out = to_binary(&AllowanceResponse {
                allowance: Uint128::from(allowance),
            })?;
            Ok(out)
        }
    }
}
```

