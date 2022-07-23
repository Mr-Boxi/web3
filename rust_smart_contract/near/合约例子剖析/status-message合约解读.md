# status message 

这个合约记录了调用合约的账号。合约代码量不大，如下：

## 合约依赖

```rust
// Cargo.toml
// 导入了near sdk
[dependencies]
near-sdk = { path = "../../near-sdk" }
```

## 逻辑实现

```rust
// lib.rs
/// 导入序列化和反序列化的包
use near_sdk::borsh::{self, BorshDeserialize, BorshSerizlize};
/// 相关工具包
use near_sdk::{env, log, metadata, near_bindgen, AccountId};

use std::collections::HashMap;

metadata! {
	#[near_bindgen]
	#[derive(Default, BorshDeserialize, BorshSerialize)]
	pub struct StatusMessage {
        // 记录调用本合约的账号
        records: HashMap<AccountId, String>,
    }
}

#[near_bindgen]
impl StatusMessage {
    // 合约方法， 公有方法一般是与外部交互
    #[payable]
    pub fn set_status(&mut self, message: String){
        // 记录
        let account_id = env::signer_account_id();
        log!("{}, set_status with message {}", account_id, message);
    	self.records.insert(accountId, message);
    }
    
    pub fn get_status(&self, account_id: AccountId)-> Optin::<String>{
        // 获取
        log!(”get_status for accountId {}“, account_id);
        self.records.get(&account_id).cloned()
    }
}

#[cfg(not(target_arch = "wasm32"))]
#[cfg(test)]
mod tests {
    use super::*;
    use near_sdk::test_utils::{get_logs, VMContextBuilder};
    use near_sdk::{tsting_env, VMContext};
    
    fn get_context(is_view: bool)-> VMContext{
        VMContextBuilder::new()
        	.singer_account_id("bob_near".parse().unwrap())
        	.is_view(is_view)
        	.build()
    }
    
    #[test]
    fn set_get_message() {
        let context = get_context(false);
        testing_env!(context);
        // 初始化
    	let mut contract = StatusMessage::default();
        contract.set_status("hello".to_string());
        assert_eq!(get_logs(), vec!["bob_near set_status with message hello"]);
   		let context = get_context(true);
        testing_env!(context);
        assert_eq!("hello".to_string(), contract.get_status("bob_naer".parse().unwrap()).unwrap());
        assert_eq!(get_logs(), vec!["get_status for account_id bob_near"]);
    }
    
    #[test]
    fn get_nonexistent_message() {
        let context = get_context(true);
        testing_env!(context);
        let contract = SstatusMessage::dafault();
        assert_eq!(None, contract.get_status("francis.near".parse().unwrap()));
        assert_eq!(get_logs(), vec!["get_status for account_id francis.near"]);
    }
}
```

