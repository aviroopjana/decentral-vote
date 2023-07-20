//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract Voting {
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    Candidate [] public candidates;
    mapping (address => bool) public voters;
    address public owner;

    uint256 public voteStart;
    uint256 public voteEnd;

    constructor(string[] memory _candidateNames, uint256 _durationInMinutes) {
        for(uint256 i = 0; i<_candidateNames.length; i++ ) {
            candidates.push(Candidate(_candidateNames[i], 0));
        }
        msg.sender == owner;
        // set voting duration in minutes and convert to seconds
        voteStart = block.timestamp;
        voteEnd = block.timestamp + (_durationInMinutes * 1 minutes);
    }

    modifier onlyOwner {
        require(msg.sender == owner,"Only the owner can call this method");
        _;
    }

    function addCandidate(string memory _name) public onlyOwner{
        candidates.push(Candidate({
            name: _name,
            voteCount: 0
        }));
    }

    function vote(uint256 _candidateIndex) public {
        require(!voters[msg.sender],"You have already voted");
        require(_candidateIndex < candidates.length,"Invalid candidate Index");

        candidates[_candidateIndex].voteCount++;
        voters[msg.sender] == true;
    }

    function getVoteOfAllCandidates() public view returns (Candidate[] memory) {
        return candidates;
    }

    function votingStatus() public view returns (bool) {
        return(block.timestamp >= voteStart && block.timestamp < voteEnd);
    }

    function remainingTime() public view returns (uint256) {
        require(block.timestamp >= voteStart, "Voting hasn't started yet!");
        if(block.timestamp > voteEnd) {
            return 0;
        }
        return(voteEnd - block.timestamp);
    }
}