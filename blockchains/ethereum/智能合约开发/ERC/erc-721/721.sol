// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/*
 * - 721 接口
 * - 721 元信息接口
 * - 165 接口
 * - 接收token 接口
 * - SupportsInterface
 * - 地址库
 * - ownable 权限控制合约
 * - token 实现逻辑合约
 */

//////////////////////////////////////////////////////
//  721标准接口 ERC721
/////////////////////////////////////////////////////
interface ERC721 {
    // 转账事件
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    // 授权事件
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    // 授权事件
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    // 转账
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata _data) external;
    // 转账
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
    // 转账
    function transferFrom(address _from, address _to, uint256 _tokenId) external;
    // 授权
    function approve(address _approved, uint256 _tokenId) external;
    // 授权
    function setApprovalForAll(address _operator, bool _approved) external;
    // 余额
    function balanceOf(address _owner) external view returns (uint256);
    // 查询拥有者地址
    function ownerOf(uint256 _tokenId) external view returns (address);
    // 查询被授权者地址
    function getApproved(uint256 _tokenId) external view returns (address);
    // 查询是否将所有nft授权给第三方
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);

}
///////////////////////////////////////////////////////
//  721元信息接口: ERC721Metadata
//////////////////////////////////////////////////////
interface ERC721Metadata {
    // nft 的名字
    function name() external view returns (string memory _name);
    // nft 的象征符号
    function symbol() external view returns (string memory _symbol);
    // token 的URI
    function tokenURI(uint256 _tokenId) external view returns (string memory);
}

///////////////////////////////////////////////////////
//  165接口:
//////////////////////////////////////////////////////
interface ERC165 {
    function supportsInterface(bytes4 _interfaceID) external view returns (bool);
}

interface ERC721TokenReceiver {
    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4);
}

///////////////////////////////////////////////////////
//  支持接口合约: SupportsInterface
//////////////////////////////////////////////////////
contract SupportsInterface is ERC165 {
    /**
     * @dev Mapping of supported intefraces. You must not set element 0xffffffff to true.
     */
    mapping(bytes4 => bool) internal supportedInterfaces;

    constructor(){
        supportedInterfaces[0x01ffc9a7] = true; // ERC165
    }
    // Function to check which interfaces are suported by this contract
    function supportsInterface(bytes4 _interfaceID) external override view returns (bool){
        return supportedInterfaces[_interfaceID];
    }
}

///////////////////////////////////////////////////////
//  地址工具库
//////////////////////////////////////////////////////
library AddressUtils {
    function isContract(address _addr) internal view returns (bool addressCheck){
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        assembly { codehash := extcodehash(_addr) } // solhint-disable-line
        addressCheck = (codehash != 0x0 && codehash != accountHash);
    }
}
///////////////////////////////////////////////////////
//  权限控制合约
//////////////////////////////////////////////////////
contract Ownable {
    // 消息错误码
    string constant NOT_CURRENT_OWNER = "018001";
    string constant CANNOT_TRANSFER_TO_ZERO_ADDRESS = "018002";
    string constant CANNOT_MINT = "018003";

    // 合约拥有者
    address public owner;

    // 合约拥有者转移事件
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // 合约构造函数
    constructor(){
        owner = msg.sender;
    }

    // 仅合约拥有者可以调用
    modifier onlyOwner(){
        require(msg.sender == owner, NOT_CURRENT_OWNER);
        _;
    }

    // 合约所有者转移
    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), CANNOT_TRANSFER_TO_ZERO_ADDRESS);
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }

    /////////////////////////////////////////////////////////////////
    ///     CURD  of  whitelist
    ///     白名单权限控制函数
    ////////////////////////////////////////////////////////////////
    mapping (address => bool) whitelist;

    // need to have the power to mint the nft
    // 调用者是否有权力铸造nft
    // 合约拥有者可以mint，或者白名单中的人可以mint
    modifier canMint() {
        require(owner == msg.sender || whitelist[msg.sender], CANNOT_MINT);
        _;
    }

    // add a address which can mint nft
    // 往白名单中添加一个地址
    function Add(address _whiteAddr) onlyOwner external {
        whitelist[_whiteAddr] = true;
    }

    // delete a address from whilelist
    // 向白名单删除一个地址
    function Delete(address _whiteAddr) onlyOwner external {
        delete whitelist[_whiteAddr];
    }

    // query a addres which can mint a nft
    // 查询一个地址是否有铸造token的能力
    function Query(address _whiteAddr) view external returns ( bool ){
        return whitelist[_whiteAddr];
    }

}
///////////////////////////////////////////////////////
//  nft实现逻辑
//////////////////////////////////////////////////////
contract nft_boxi is
ERC721,
ERC721Metadata,
SupportsInterface,
Ownable
{
    using AddressUtils for address;

    // 消息错误码
    string constant ZERO_ADDRESS = "003001";
    string constant NOT_VALID_NFT = "003002";
    string constant NOT_OWNER_OR_OPERATOR = "003003";
    string constant NOT_OWNER_APPROVED_OR_OPERATOR = "003004";
    string constant NOT_ABLE_TO_RECEIVE_NFT = "003005";
    string constant NFT_ALREADY_EXISTS = "003006";
    string constant NOT_OWNER = "003007";
    string constant IS_OWNER = "003008";

    // 接收nft的接口实现
    bytes4 internal constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;

    // 相关映射
    mapping (uint256 => address) internal idToOwner;
    mapping (uint256 => address) internal idToApproval;
    mapping (address => uint256) internal ownerToNFTokenCount;
    mapping (address => mapping (address => bool)) internal ownerToOperators;

    // 元信息接口实现相关数据结构
    string internal nftName;
    string internal nftSymbol;
    mapping (uint256 => string) internal idToUri;


    // 合约构造函数
    constructor(string memory _nftname, string memory _nftsymbol){
        nftName = _nftname;
        nftSymbol = _nftsymbol;
        supportedInterfaces[0x80ac58cd] = true; // ERC721
        supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
    }

    //////////////////////////////////////////////////////
    // 相关的函数修饰符
    /////////////////////////////////////////////////////
    // 可以操作否 - 对nft是否有操作的权利（要么是拥有者，或者被授权）
    modifier canOperate(uint256 _tokenId){
        address tokenOwner = idToOwner[_tokenId];
        require(
            tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender],
            NOT_OWNER_OR_OPERATOR
        );
        _;
    }

    // 可以转移否 - 是否可以转走nft
    // 增加需求：白名单中的地址就可以转移token, 或者合约拥有者可以转移
    modifier canTransfer(uint256 _tokenId){
        address tokenOwner = idToOwner[_tokenId];
        require(
            tokenOwner == msg.sender
            || idToApproval[_tokenId] == msg.sender
            || ownerToOperators[tokenOwner][msg.sender]
            || owner == msg.sender
            || whitelist[msg.sender],
            NOT_OWNER_APPROVED_OR_OPERATOR
        );
        _;

    }

    // 是否是有效的token
    modifier validNFToken(uint256 _tokenId){
        require(idToOwner[_tokenId] != address(0), NOT_VALID_NFT);
        _;
    }

    ///////////////////////////////////////////////////
    //  元信息接口是实现
    //////////////////////////////////////////////////
    // meta 外部调用的业务接口
    function name() external override view returns (string memory _name){
        _name = nftName;
    }
    function symbol() external override view returns (string memory _symbol)
    {
        _symbol = nftSymbol;
    }
    function tokenURI(uint256 _tokenId) external override view validNFToken(_tokenId) returns (string memory){
        return _tokenURI(_tokenId);
    }

    ///////////////////////////////////////////////////
    //  铸造与销毁
    //////////////////////////////////////////////////
    // 铸造
    function mint(address _to, uint256 _tokenId,  string calldata _uri)  external canMint {
        require(_to != address(0), ZERO_ADDRESS);
        require(idToOwner[_tokenId] == address(0), NFT_ALREADY_EXISTS);

        _addNFToken(_to, _tokenId);
        _setTokenUri(_tokenId, _uri);

        emit Transfer(address(0), _to, _tokenId);
    }
    // 批量制造
    function batchMint(
        address _to,
        uint256[] memory _tokenIds,
        string memory _uri
    )
    external
    canMint
    {
        require(_to != address(0), ZERO_ADDRESS);
        for(uint256 i = 0; i < _tokenIds.length; i++ ){

            require(idToOwner[_tokenIds[i]] == address(0), NFT_ALREADY_EXISTS);
            idToOwner[_tokenIds[i]] = _to;
            ownerToNFTokenCount[_to] += 1;
            idToUri[_tokenIds[i]] = _uri;
            //_addNFToken(_to, val);
            //_setTokenUri(val, _uri);
            emit Transfer(address(0), _to, _tokenIds[i]);
        }
    }
    // 销毁
    function burn(uint256 _tokenId) external validNFToken(_tokenId) {
        address tokenOwner = idToOwner[_tokenId];
        // 权限校验--- 是否是拥有者
        require(tokenOwner == msg.sender, NOT_OWNER);
        _clearApproval(_tokenId);
        _removeNFToken(tokenOwner, _tokenId);
        delete idToUri[_tokenId];
        emit Transfer(tokenOwner, address(0), _tokenId);
    }

    ///////////////////////////////////////////////////
    //  721标准接口接口是实现
    //////////////////////////////////////////////////
    // standard --- 外部调用的业务接口
    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes calldata _data
    )
    external
    override
    {
        _safeTransferFrom(_from, _to, _tokenId, _data);
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    )
    external
    override
    {
        _safeTransferFrom(_from, _to, _tokenId, "");
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external override
    canTransfer(_tokenId)
    validNFToken(_tokenId)
    {
        address tokenOwner = idToOwner[_tokenId];
        require(tokenOwner == _from, NOT_OWNER);
        require(_to != address(0), ZERO_ADDRESS);

        _transfer(_to, _tokenId);
    }
    function approve(address _approved, uint256 _tokenId) external override
    canOperate(_tokenId)
    validNFToken(_tokenId)
    {
        address tokenOwner = idToOwner[_tokenId];
        require(_approved != tokenOwner, IS_OWNER);

        idToApproval[_tokenId] = _approved;
        emit Approval(tokenOwner, _approved, _tokenId);
    }
    function setApprovalForAll(address _operator, bool _approved) external override {
        ownerToOperators[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }
    function balanceOf(address _owner) external override view returns (uint256){
        require(_owner != address(0), ZERO_ADDRESS);
        return _getOwnerNFTCount(_owner);
    }
    function ownerOf(uint256 _tokenId) external override view returns (address _owner){
        _owner = idToOwner[_tokenId];
        require(_owner != address(0), NOT_VALID_NFT);
    }
    function getApproved(uint256 _tokenId) external override view
    validNFToken(_tokenId)
    returns (address)
    {
        return idToApproval[_tokenId];
    }
    function isApprovedForAll(address _owner, address _operator) external override view returns (bool)
    {
        return ownerToOperators[_owner][_operator];
    }

    /////////////////////////////////////////////////////////////////////////////////////
    /// 逻辑实现
    /// 内部调用
    /////////////////////////////////////////////////////////////////////////////////////
    function _transfer(address _to, uint256 _tokenId) internal {
        address from = idToOwner[_tokenId];
        _clearApproval(_tokenId);

        _removeNFToken(from, _tokenId);
        _addNFToken(_to, _tokenId);

        emit Transfer(from, _to, _tokenId);
    }
    function _safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory _data
    )
    private
    canTransfer(_tokenId)
    validNFToken(_tokenId)
    {
        address tokenOwner = idToOwner[_tokenId];
        require(tokenOwner == _from, NOT_OWNER);
        require(_to != address(0), ZERO_ADDRESS);

        _transfer(_to, _tokenId);

        if (_to.isContract())
        {
            bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
            require(retval == MAGIC_ON_ERC721_RECEIVED, NOT_ABLE_TO_RECEIVE_NFT);
        }
    }
    function _removeNFToken(address _from, uint256 _tokenId) internal virtual {
        require(idToOwner[_tokenId] == _from, NOT_OWNER);
        ownerToNFTokenCount[_from] -= 1;
        delete idToOwner[_tokenId];
    }
    function _addNFToken(address _to, uint256 _tokenId) internal virtual {
        require(idToOwner[_tokenId] == address(0), NFT_ALREADY_EXISTS);

        idToOwner[_tokenId] = _to;
        ownerToNFTokenCount[_to] += 1;
    }
    function _getOwnerNFTCount(address _owner) internal virtual view returns (uint256){
        return ownerToNFTokenCount[_owner];
    }
    function _clearApproval(uint256 _tokenId) private {
        delete idToApproval[_tokenId];
    }

    // idtouri的读写
    function _tokenURI(uint256 _tokenId) internal virtual view returns (string memory){
        return idToUri[_tokenId];
    }
    function _setTokenUri(uint256 _tokenId, string memory _uri) internal validNFToken(_tokenId) {
        idToUri[_tokenId] = _uri;
    }
}