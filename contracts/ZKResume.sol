// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract ZKResume {
    address public owner;

    struct Resume {
        address user;
        string ipfsHash; // Encrypted resume stored off-chain (e.g., on IPFS)
        bytes32 zkProofHash; // Hash of the ZK proof
        bool verified;
    }

    mapping(address => Resume) public resumes;

    event ResumeSubmitted(address indexed user, string ipfsHash, bytes32 zkProofHash);
    event ResumeVerified(address indexed user);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can verify resumes");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function submitResume(string memory _ipfsHash, bytes32 _zkProofHash) external {
        resumes[msg.sender] = Resume({
            user: msg.sender,
            ipfsHash: _ipfsHash,
            zkProofHash: _zkProofHash,
            verified: false
        });

        emit ResumeSubmitted(msg.sender, _ipfsHash, _zkProofHash);
    }

    function verifyResume(address _user) external onlyOwner {
        require(resumes[_user].user != address(0), "Resume does not exist");
        resumes[_user].verified = true;

        emit ResumeVerified(_user);
    }

    function getResume(address _user) external view returns (string memory, bytes32, bool) {
        Resume memory resume = resumes[_user];
        return (resume.ipfsHash, resume.zkProofHash, resume.verified);
    }
}
