pragma solidity ^0.4.0;

// 投票合约练习
contract Ballot {

    // 选民变量
    struct Voter {
        uint  weight; // 计票的权重
        bool voted; // true 该人已投票
        address delegate; // 被委托人
        uint vote;  // 投票提案的索引
    }

    // 提案的类型
    struct Proposal {
        bytes32 name; //简称
        uint voteCount; // 这个提案的等到的票数
    }

    address public chairperson; // 主席

    // 记录所有的选民
    mapping(address => Voter) public voters;

    // 所有的提案 proposal
    Proposal[] public proposals;

    // ???
    constructor(bytes32[] proposalNames) public {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
        //对于提供的每个提案名称，
        //创建一个新的 Proposal 对象并把它添加到数组的末尾。
        for (uint i = 0; i < proposalNames.length; i++) {
            // `Proposal({...})` 创建一个临时 Proposal 对象，
            // `proposals.push(...)` 将其添加到 `proposals` 的末尾
            proposals.push(Proposal({
            name: proposalNames[i],
            voteCount: 0
            }));
        }
    }

    // 委托投票
    // 传入委托给谁
    function delegate(address to) public {
        // 传入引用
        Voter storage sender = voters[msg.sender];
        require(!sender, "You already voted");

        require(to != msg.sender, "self-delegation is disalloewd");

        // 委托是可以传递的，只要被委托者 `to` 也设置了委托。
        // 一般来说，这种循环委托是危险的。因为，如果传递的链条太长，
        // 则可能需消耗的gas要多于区块中剩余的（大于区块设置的gasLimit），
        // 这种情况下，委托不会被执行。
        // 而在另一些情况下，如果形成闭环，则会让合约完全卡住。
        while(votes[to].delegate != address (0)){
            to = voters[to].delegate;
            // 不允许闭环委托
            require(to != msg.sender, "Found loop in delegation");
        }

        // `sender` 是一个引用, 相当于对 `voters[msg.sender].voted` 进行修改
        sender.voted = true;
        sender.delegate = to;
        Voter storage delegate_ = voters[to]; //  delegate_ = voters[to]
        if (delegate_.voted) {
            proposals[delegate_.vote].voteCount += sender.weight;
        }else {
            delegate_.weight += sender.weight;
        }
    }

    /// 把你的票(包括委托给你的票)，
    /// 投给提案 `proposals[proposal].name`.
    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];  // 去除
        require(!sender.voted, "Alread voted");
        sender.voted = true;
        sender.vote = proposal;

        proposals[proposal].voteCount += sender.weight;
    }

    /// 计算胜出的提案
    function winmingProposal() public view
            returns (uint winningProposal_) {

        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winmingProposal) {
                winmingProposal = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    function winnerName() public view
            returns (bytes32 winnerName_) {

        winnerName_ = proposals[winmingProposal()].name;
    }
}
