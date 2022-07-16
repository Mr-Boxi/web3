pragma solidity ^0.8.13;

// 在合约部署之前， 合约地址可以提前计算 --- create2
contract Factory {
    // 返回最新部署的合约地址
    function deploy(address _owner, uint _foo, bytes32 _salt)public payable returns (address){
        return address(new TestContract{salt: _salt}(_owner, _foo));
    }
}

// this is the older way of doing it using assembly
contract FactoryAssembly{
    event Deployed(address addr, uint salt);

    // 1. get bytecode of contract to be deployed
    function getBytecode(address _owner, uint _foo) public pure returns(bytes memory){
        bytes memory bytecode = type(TestContract).creationCode;
        return abi.encodePacked(bytecode, abi.encode(_owner, _foo));
    }

    // 2. compute the address of the contract to be deployed
    function getAddress(bytes memory bytecode, uint _salt) public view returns(address) {
        bytes32 hash = keccak256(abi.encodePacked(bytes1(0xff), address(this), _salt, keccak256(bytecode)));
        return address(uint160(uint(hash)));
    }

    // 3. deploy the contract
    function deploy(bytes memory bytecode, uint _salt) public payable{
        address addr;


        /*
        NOTE: How to call create2

        create2(v, p, n, s)
        create new contract with code at memory p to p + n
        and send v wei
        and return the new address
        where new address = first 20 bytes of keccak256(0xff + address(this) + s + keccak256(mem[p…(p+n)))
              s = big-endian 256-bit value
        */
        assembly {
            addr := create2(
            callvalue(),
            add(bytecode, 0x20),
            mload(bytecode),
            _salt
            )
            if iszero(extcodesize(addr)){
                revert(0, 0)
            }
        }
        emit Deployed(addr, _salt);
    }
}

contract TestContract {
    address public owner;
    uint public foo;

    constructor(address _owner, uint _foo) payable {
        owner = _owner;
        foo = _foo;
    }

    function getBalance() public view returns (uint){
        return address(this).balance;
    }
}