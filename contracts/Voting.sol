// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract Voting {
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    struct Voter {
        bool hasVoted;
        uint256 votedCandidateIndex;
    }

    Candidate[] public candidates;
    mapping(address => Voter) public voters;
    address public owner;

    uint256 public voteStart;
    uint256 public voteEnd;

    constructor(string[] memory _candidateNames, uint256 _durationInMinutes) {
        for (uint256 i = 0; i < _candidateNames.length; i++) {
            candidates.push(Candidate(_candidateNames[i], 0));
        }
        owner = msg.sender;
        // Set voting duration in minutes and convert to seconds
        voteStart = block.timestamp;
        voteEnd = block.timestamp + (_durationInMinutes * 1 minutes);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this method");
        _;
    }

    modifier onlyDuringVoting {
        require(
            block.timestamp >= voteStart && block.timestamp < voteEnd,
            "Voting is not active"
        );
        _;
    }

    modifier onlyBeforeVoting {
        require(block.timestamp < voteStart, "Voting has already started");
        _;
    }

    modifier onlyAfterVoting {
        require(block.timestamp >= voteEnd, "Voting is still active");
        _;
    }

    function addCandidate(string memory _name) public onlyOwner onlyBeforeVoting {
        candidates.push(Candidate({name: _name, voteCount: 0}));
    }

    function vote(uint256 _candidateIndex) public onlyDuringVoting {
        Voter storage sender = voters[msg.sender];
        require(!sender.hasVoted, "You have already voted");
        require(_candidateIndex < candidates.length, "Invalid candidate index");

        sender.hasVoted = true;
        sender.votedCandidateIndex = _candidateIndex;
        candidates[_candidateIndex].voteCount++;
    }

    function getVoteOfAllCandidates() public view returns (Candidate[] memory) {
        return candidates;
    }

    function votingStatus() public view returns (bool) {
        return (block.timestamp >= voteStart && block.timestamp < voteEnd);
    }

    function remainingTime() public view returns (uint256) {
        if (block.timestamp < voteStart) {
            return voteStart - block.timestamp;
        } else if (block.timestamp >= voteEnd) {
            return 0;
        } else {
            return voteEnd - block.timestamp;
        }
    }

    function getVoterVote() public view onlyAfterVoting returns (string memory) {
        Voter storage sender = voters[msg.sender];
        require(sender.hasVoted, "You have not voted");
        return candidates[sender.votedCandidateIndex].name;
    }
}
