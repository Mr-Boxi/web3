## erc20

使用ink 开发的同质化代币合约。

从存储，消息，事件分析

###  erc20 前置知识

...

### storage 存储

```rust
#[ink(storage)]
#[derive(SpreadAllocate)]
pub struct Erc20 {
    /// token 的总供应量
    total_supply: Balance,
	/// owner -> balance
    balances: Mapping<AccountId, Balance>,
    /// 授权许可情况
    allowances: Mapping<(AccountId, AccountId), Balance>
}
```

### event 事件

```rust
/// 转账事件
#[ink(event)]
pub struct Transfer {
    #[ink(topic)]
    from: Option<AccountId>,
    to: Option<AccountId>,
    value: Balance,
}

/// 授权事件
#[ink(event)]
pub struct Approval {
    #[ink(topic)]
    owner: AccountId,
    #[ink(topic)]
    spender: AccountId,
    value: Balance,
}
```

### error

```rust
/// erc-20 error types
#[derive(Debug, PartialEq, Eq, scale::Encode, scale::Decode)]
#[cfg_attr(feature = "std", derive(scale_info::TypeInfo))]
pub enum Error {
    /// 余额不足
    InsufficientBalance,
    /// 授权情况的错误
    InsufficientAllowance,
}
/// the erc-20 result type
pub type Result<T> = core::result::Result<T, Error>;
```

### message

执行逻辑实现

```rust
impl Erc20 {
    /// 构造函数1
    #[ink(constructor)]
    pub fn new(initial_supply: Balance) -> Self {
        ink_lang::utils::initialize_contract( |contract|
        	Self::new_init(contract, initial_supply)
        )
    }
    /// 构造函数2
    fn new_init(&mut self, initial_supply: Balance){
        let caller = Self::env.caller();
        self.balances.insert(&caller, &initial_supply);
        self.total_supply = initial_supply;
        Self::env().emit_event(Transfer {
            from: None,
            to: Some(caller),
            value: initial_supply,
        });
    }
    
    /// 返回代币总供应量
    #[ink(message)]
    pub fn total_supply(&self) -> Balance{ self.total_supply}
    
    /// 查询账号余额
    #[ink(message)]
    pub fn balance_of(&self, owner: AccountId) -> Balance { self.balance_of_impl(&owner)}
    
    #[inline]
    fn balance_of_impl(&self, owner: &AccountId) -> Balance {
        self.balances.get(owner).unwrap_or_default()
    }
    
    /// 授权
    #[ink(message)]
    pub fn allowance(&self, owner: AccountId, spender: AccountId)-> Balance{
        self.allowance_impl(&owner, &spender)
    }
    ///[inline]
    fn allowance_impl(&self, owner:&AccountId, spender: &AcountId) -> Balance {
        self.allowances.get((owner, spender)).unwrap_or_default()
    }
    
    /// 转账
    #[ink(message)]
    pub fn transfer(&mut self, to: AccountId, value: Balance) -> Result<()>{
        let from = self.env().caller();
        self.transfer_from_to(&from, &to, value)
    }
    
    /// 授权
    #[ink(message)]
    pub fn approve(&mut self, spender: AccountId, value: Balance) -> Result<()> {
        let owner = self.env().caller();
        self.allowances.insert((&owner, &spender), &value);
        self.env().emit_event(Approval {
            owner,
            spender,
            value,
        });
        Ok(())
    }
    
    /// 转账 
    #[ink(message)]
    pub fn transfer_from(
    	&mut self, 
        from: AccountId,
        to: AccountId,
        value: Balance,
    ) -> Result<()> {
        let caller = self.env().caller();
        let allowance = self.allowance_impl(&from, &caller);
        if allowance < value {
            return Err(Error::InsufficientAllowance)
        }
        self.transfer_from_to(&from, &to, value)?;
        self.allowances
        	.insert((&from, &caller), &(allowance - value));
    }
    
    fn transfer_from_to(
    	&mut self,
        from: &AccountId,
        to: &AccountId,
        value: Balance,
    ) -> Result<()> {
        let from_balance = self.balance_of_impl(from);
        if from_balance < value {
            return Err(Error::InsufficientBalance)
        }
        
        self.balances.insert(from, &(from_balance -value));
        let to_balance = self.balance_of_impl(to);
        self.balances.insert(to, &(to_balance + value));
        self.env().emit_event(Transfer {
            from: Some(*from),
            to: Some(*to),
            value,
        });
        Ok(())
    }
```



