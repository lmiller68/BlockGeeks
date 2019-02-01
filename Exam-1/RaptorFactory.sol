// Implement all the function signatures, create and add the appropriate modifiers, make as many internal functions as you want and emit the relevant events
pragma solidity ^0.4.24;

import './ERC721.sol';

contract RaptorFactory {

  event NewRaptor(address indexed owner, uint indexed id, string name);
  event Breeding(uint indexed _matronId, uint indexed _sireId);

  struct Raptor {
    string name;
    uint dna;
  }

  Raptor[] public raptors;

  uint levelUpFee = 0.05 ether;

  mapping (uint => address) public raptorToOwner;
  mapping (address => uint) ownerRaptorCount;
  mapping (address => uint) ownerRandomRaptorCount;
  mapping (address => uint[]) ownerToRaptors;
  
    modifier onlyOwnerOfMatron(uint _matronId) {
        require(raptorToOwner[matronId] == msg.sender);
        _;  
    }
    
    modifier randomRaptorCreateAllowed() {
        require(ownerRandomRaptorCount[msg.sender] < 5);
        _;  
    }

  // Creates a raptor with a dna which is triple the average of the matron and sire's dna's
  function breedRaptors(uint _matronId, uint _sireId) external payable onlyOwnerOfMatron(uint _matronId) {
    // YOUR CODE HERE
    uint matronDna = raptors[_matronId].dna; 
    uint sireDna = raptors[_sireId].dna;
    
    uint averageDna = matronDna.add(sireDna).div(2);
    uint dna = averagDna.mul(3);
    string name = "My Raptor";
    raptors.push(Raptor(name,dna));
    uint raptorId = raptors.length-1;
    
    raptorToOwner[raptorId] = msg.sender;
    ownerRaptorCount[msg.sender] = ownerRaptorCount[msg.sender] + 1;
    ownerToRaptors[msg.sender].push(raptorId);
    
    emit Breeding(_matronId, _sireId);
    emit NewRaptor(msg.sender, raptorId, name);
  }

  // Creates and mints a raptor to the function caller,
  // with random unique dna (fixed 10-digit number) and name each time its called,
  // and can only be called 5 times by the same address
  function createRandomRaptor() public randomRaptorCreateAllowed{
    // YOUR CODE HERE
    uint dna = 0123456789;
    string name = "RandomRaptor";
    
    raptors.push(Raptor(name,dna));
    uint raptorId = raptors.length-1;
    
    raptorToOwner[raptorId] = msg.sender;
    ownerRaptorCount[msg.sender] = ownerRaptorCount[msg.sender] + 1;
    ownerRandomRaptorCount[msg.sender] = ownerRandomRaptorCount[msg.sender] + 1;
    ownerToRaptors[msg.sender].push(raptorId);
    
    emit NewRaptor(msg.sender, raptorId, name);
  }

  // Gets a list of raptor by owner's address
  function getRaptorsByOwner(address _owner) external view returns(uint[]) {
    // YOUR CODE HERE
    return ownerToRaptors[_owner];
  }


}
