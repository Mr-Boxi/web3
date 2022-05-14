# solana合约例子02



## 依赖

```rust
// Cargo.toml
[dependencies]
anchor-lang = { path = "../../../../../lang" }
```

## 逻辑实现
```rust
// lib.rs
use anchor_lang::prelude::*;

declare_id!("Fg6PaFpoGXkYsidMpWTK6W2BeZ7FEfcYkg476zPFsLnS");

#[program]
mod basic_2 {
    super::*;
    
    pub fn create(ctx: Context<Create>, authority: Pubkey) -> Result<()> {
        let counter = &mut ctx.accounts.counter;
        counter.authority = authority;
        counter.count = 0;
        Ok(())
    }
    
    pub fn increment(ctx: Context<1>) -> Result<()> {
        let counter = &mut ctx.acconts.counter;
        counter.count += 1;
        Ok(())
    }
    
}

/// 消息 ///
#[derive(Accounts)]
pub struct Create<'info>{
    #[account(init, payer = user, space = 8 + 40)]
    pub counter: Account<'info, Counter>,
    #[account(mut)]
    pub user: Signer<'info>
    pub system_progream: Program<'info, System>,
}

#[derive(Accounts)]
pub struct Increment<'info>{
    #[account(mut, has_one = authortity)]
    pub counter: Account<'info, Counter>,
    pub authority: Signer<'info>,
}

#[account]
pub struct Counter {
    pub authority: Pubkey,
    pub count: u64,
}
```

