// Given the following election contract which uses the hash-commit-reveal scheme,
// implement the logic for the constructor, commitVote() and revealVote() functions.
// Assume that vote hashes are generated using keccak256,
// and votes are submitted in the format: “1-somepassword” (if voting for choice1 )
// or “2-someotherpassword” (if voting for choice2).
// Voters can only submit one vote and reveal one vote.
// All submitted votes must be revealed before announcing a winner.
// Add any state variables or functions you need, and emit the ElectionWinner event to announce the winner.

pragma solidity 0.4.24;

contract CommitRevealElection {
    string public candidate1;
    string public candidate2;
    uint public commitPhaseEndTime;
    uint public votesForCandidate1;
    uint public votesForCandidate2;
    
    bytes32[] public voteCommits;
    mapping(bytes32 => string) voteStatuses; 

    event ElectionWinner(string winner, uint voteCount);
    event logEvents(string msg;)

    // Add any other state variables you need

    constructor(uint _commitPhaseDurationInMinutes, string _candidate1, string _candidate2) public {
        candidate1 = _candidate1;
        candidate2 = _candidate2;
        commitPhaseEndTime = now + _commitPhaseDurationInMinutes * 1 minutes;
    }

    // _voteHash is computed based on the keccak256 of user's
    // vote and their password of their choice
    // e.g. keccak256('1-votersPassword')
    function submitVote(bytes32 _voteHash) public {
        require(now < commitPhaseEndTime);

        bytes memory voteHash = bytes(voteStatuses[_voteHash]);
        if (voteHash.length != 0) throw;
        
        voteCommits.push(_voteHash);
        voteStatuses[_voteHash] = "Submitted";
    }

    // _vote is the msg that was hashed in submitVote (e.g. '1-votersPassword')
    // Add checks to make sure the _vote is in the correct format,
    // otherwise don't count the vote.
    function revealVote(string _vote) public {
        require(now > commitPhaseEndTime);
        voteHash = keccak256(_vote);
        bytes memory bytesVoteStatus = bytes(voteStatuses[_voteHash]);
        if (bytesVoteStatus.length == 0) {
            logString('A vote with this voteCommit was not cast');
        } else if (bytesVoteStatus[0] != 'S') {
            logEvents('This vote was already cast');
            return;
        }
        
        bytes memory bytesVote = bytes(_vote);
        if (bytesVote[0] == '1') {
            votesForCandidate1 = votesForCandidate1 + 1;
        }
        if (bytesVote[0] == '2') {
            votesForCandidate2 = votesForCandidate2 + 1;
        }
        voteStatuses[voteHash] = "Revealed";
    }

    // Only announce winner when everyone who submitted their vote has revealed their vote
    function announceWinner() public {
        require(now < commitPhaseEndTime);
        require(votesForCandidate1 + votesForCandidate2 = voteCommits.length);
        
        if (votesForCandidate1 > votesForCandidate2) {
            emit ElectionWinner(candidate1, votesForCandidate1);
        } else if (votesForCandidate2 > votesForCandidate1) {
            emit ElectionWinner(candidate2, votesForCandidate2);
        } else if (votesForCandidate1 == votesForCandidate2) {
            emit ElectionWinner("It was a tie.", votesForCandidate1);
        }
    }
}

