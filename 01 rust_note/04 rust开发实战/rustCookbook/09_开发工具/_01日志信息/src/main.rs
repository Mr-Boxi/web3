/*
    日志信息
 */

use log;
use env_logger;
// 记录调式信息到控制台
fn execute_query(query: &str){
    // log crate 提供了日志工具
    log::debug!("Executing query: {}", query);
    log::info!("Executing query: {}", query);
}

fn main() {
    // env_logger crate 通过环境变量配置日志记录
    env_logger::init();
    execute_query("drop table");
}
