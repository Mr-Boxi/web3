// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// TimeLock 是一种合约，用于发布未来要执行的交易。在最短的等待期之后，可以执行交易。
// used in daos 
contract TimeLock{
    error NotOwnerError();
    error AlreadyQueueDError(bytes32 txId);
    error TimestampNotInRangeError(uint blcokTimestamp, uint timestamp);
    error NotQueuedError(bytes32 txId);
    error TimestampNotPassedError(uint blockTimestamp, uint timestamp);
    error TimestampExpiredError(uint blockTimestamp, uint expiresAt);
    error TxFailedError();

    event Queue(bytes32 indexed txId, address indexed target, uint value, string func, bytes data, uint timestamp);
    event Execute(bytes32 indexed txId, address indexed target, uint value, string func, bytes data, uint timestamp);
    event Cancel(bytes32 indexed txId);

    uint public constant MIN_DELAY = 10; // seconds
    uint public constant MAX_DELAY = 1000; // seconds
    uint public constant GRACE_PERIOD = 1000; // seconds

    address public owner;
    // tx id => queued
    mapping(bytes32 => bool) public queued;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert NotOwnerError();
        }
        _;
    }

    receive() external payable {}


    function getTxId(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    )
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encode(_target, _value, _func,_data, _timestamp));
    }


    function queue(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    )
        external
        onlyOwner
        returns (bytes32 txId)
    {
        txId = getTxId(_target, _value, _func, _data, _timestamp);
        if (queued[txId]){
            revert AlreadyQueueDError(txId);
        }

        // --- | -------------- | ------------------| ---------
        //   block          block + min           block + max
        if (
            _timestamp < block.timestamp + MIN_DELAY ||
            _timestamp > block.timestamp + MAX_DELAY
        ){
            revert TimestampNotInRangeError(block.timestamp, _timestamp);
        }

        queued[txId] = true;
    
        emit Queue(txId, _target, _value, _func, _data, _timestamp);
    }

    function execute(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    )
        external
        payable
        onlyOwner
        returns (bytes memory)
    {
        bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);
        if (!queued[txId]){
            revert NotQueuedError(txId);
        }
        // ----|-------------------|-------
        //  timestamp    timestamp + grace period   
        if (block.timestamp < _timestamp) {
             revert TimestampNotPassedError(block.timestamp, _timestamp);
        }
        if (block.timestamp > _timestamp + GRACE_PERIOD){
            revert TimestampExpiredError(block.timestamp, _timestamp + GRACE_PERIOD);
        }

        queued[txId] = false;

        // prepare data 
        bytes memory data;
        if (bytes(_func).length > 0) {
            data = abi.encodePacked(bytes4(keccak256(bytes(_func))), _data);
        }else {
            data = _data;
        }

        // call target
        (bool ok, bytes memory res) = _target.call{value: _value}(data);
        if(!ok){
            revert TxFailedError();
        }

        emit Execute(txId, _target, _value, _func, _data, _timestamp);
        return res;
    }

    function cancel(bytes32 _txId) external onlyOwner {
        if (!queued[_txId]) {
            revert  NotQueuedError(_txId);
        }
        queued[_txId] = false;
        emit Cancel(_txId);
    }
}