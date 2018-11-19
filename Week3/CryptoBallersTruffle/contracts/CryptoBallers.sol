pragma solidity ^0.4.24;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';

contract CryptoBallers is ERC721 {

    struct Baller {
        string name;
        uint level;
        uint offenseSkill;
        uint defenseSkill;
        uint winCount;
        uint lossCount;
    }

    address owner;
    Baller[] public ballers;

    // Mapping for if address has claimed their free baller
    mapping(address => bool) claimedFreeBaller;
    
    // Mapping from owner to array of Token IDs owned 
    mapping (address => uint256[]) internal ownedBallers;

    
    // Fee for buying a baller
    uint ballerFee = 0.10 ether;

    /**
    * @dev Ensures ownership of the specified token ID
    * @param _tokenId uint256 ID of the token to check
    */
    modifier onlyOwnerOf(uint256 _tokenId) {
        // TODO add your code
        require(_isApprovedOrOwner(msg.sender, _tokenId));
        _;
    }

    /**
    * @dev Ensures ownership of contract
    */
    modifier onlyOwner() {
        // TODO add your code
        require(msg.sender == owner);
        _;
    }

    /**
    * @dev Ensures baller has level above specified level
    * @param _level uint level that the baller needs to be above
    * @param _ballerId uint ID of the Baller to check
    */
    modifier aboveLevel(uint _level, uint _ballerId) {
        // TODO add your code
        require(_exists(_ballerId));
        _;
        require(ballers[_ballerId].level > _level);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    /**
    * @dev Allows user to claim first free baller, ensure no address can claim more than one
    */
    function claimFreeBaller() public {
        // TODO add your code
        require(claimedFreeBaller[msg.sender] != true, "You have already claimed your free baller!");
        claimedFreeBaller[msg.sender] = true;
        _createBaller("Larry Bid", 3, 3, 2);
        
    }

    /**
    * @dev Allows user to buy baller with set attributes
    */
    function buyBaller() public payable {
        // TODO add your code
        require(msg.value >= ballerFee);
        _createBaller("Larry Bid", 3, 3, 2);
    }

    /**
    * @dev Play a game with your baller and an opponent baller
    * If your baller has more offensive skill than your opponent's defensive skill
    * you win, your level goes up, the opponent loses, and vice versa.
    * If you win and your baller reaches level 5, you are awarded a new baller with a mix of traits
    * from your baller and your opponent's baller.
    * @param _ballerId uint ID of the Baller initiating the game
    * targetId uint ID that the baller needs to be above
    * EXTENSION - Each Player is assigned a random Health Value (0-10)
    * If your baller or opponent health is 5 they will play at the same skill level
    * If your ballers health is less than five they will have a temporary drop in offensive skill by 1
    * If your ballers health is greater than five they will have a temporary increase in offensive skill by 1 
    * If your opponent health is less than five they will have a temporary drop in defensive skill by 1 
    * If your opponent health is greater than five they will have a temporary increase in defensive skill by 1
    */
    function playBall(uint _ballerId, uint _opponentId) onlyOwnerOf(_ballerId) public {
        // TODO add your code
        require(_exists(_ballerId));
        require(_exists(_opponentId));
        
        uint myBallerOffense = ballers[_ballerId].offenseSkill;
        uint opponentBallerDefense = ballers[_opponentId].defenseSkill;
        
        uint myBallerHealth = randomHealth();
        uint opponentBallerHealth = randomHealth();
        
        if(myBallerHealth < 5){
            myBallerOffense = myBallerOffense - 1;
        }
        
        if(myBallerHealth > 5){
            myBallerOffense = myBallerOffense + 1;
        }
        
         if(opponentBallerHealth < 5){
            opponentBallerDefense = opponentBallerDefense - 1;
        }
        
        if(myBallerHealth > 5){
            opponentBallerDefense = opponentBallerDefense + 1;
        }
        
        if(myBallerOffense > opponentBallerDefense){
            ballers[_ballerId].winCount = ballers[_ballerId].winCount + 1;
            ballers[_opponentId].lossCount = ballers[_opponentId].lossCount + 1;
            ballers[_ballerId].level = ballers[_ballerId].level + 1;
            
            if(ballers[_ballerId].level == 5){
               (uint mLevel, uint mAttack, uint mDefense) = _breedBallers(ballers[_ballerId], ballers[_opponentId]);
                _createBaller("Magic Johnson", mLevel, mAttack, mDefense);
            }

        }
        
        if(myBallerOffense < opponentBallerDefense){
            ballers[_opponentId].winCount = ballers[_opponentId].winCount + 1;
            ballers[_ballerId].lossCount = ballers[_ballerId].lossCount + 1;
            ballers[_opponentId].level = ballers[_opponentId].level + 1;
            
            if(ballers[_opponentId].level == 5){
                (uint oLevel, uint oAttack, uint oDefense) = _breedBallers(ballers[_ballerId], ballers[_opponentId]);
                _createBaller("Magic Johnson", oLevel, oAttack, oDefense);
            }
        }
    }

    /**
    * @dev Changes the name of your baller if they are above level two
    * @param _ballerId uint ID of the Baller who's name you want to change
    * @param _newName string new name you want to give to your Baller
    */
    function changeName(uint _ballerId, string _newName) external aboveLevel(2, _ballerId) onlyOwnerOf(_ballerId) {
        // TODO add your code
        ballers[_ballerId].name = _newName;
    }

    /**
   * @dev Creates a baller based on the params given, adds them to the Baller array and mints a token
   * @param _name string name of the Baller
   * @param _level uint level of the Baller
   * @param _offenseSkill offensive skill of the Baller
   * @param _defenseSkill defensive skill of the Baller
   */
    function _createBaller(string _name, uint _level, uint _offenseSkill, uint _defenseSkill) internal {
        // TODO add your code
        ballers.push(Baller(_name, _level, _offenseSkill, _defenseSkill, 0, 0));
        uint256 ballerId = ballers.length - 1;
        _mint(msg.sender, ballerId);
        ownedBallers[msg.sender].push(ballerId);
    }

    /**
    * @dev Helper function for a new baller which averages the attributes of the level, attack, defense of the ballers
    * @param _baller1 Baller first baller to average
    * @param _baller2 Baller second baller to average
    * @return tuple of level, attack and defense
    */
    function _breedBallers(Baller _baller1, Baller _baller2) internal pure returns (uint, uint, uint) {
        uint level = _baller1.level.add(_baller2.level).div(2);
        uint attack = _baller1.offenseSkill.add(_baller2.offenseSkill).div(2);
        uint defense = _baller1.defenseSkill.add(_baller2.defenseSkill).div(2);
        return (level, attack, defense);
    }
    
    /**
    EXTENSIONS
    **/
    
   /**
    * @dev Get the total number of ballers 
    * @return number of ballers
    */
   function getNumBallers() public view returns (uint) {
        return ballers.length;
    }
   
   /**
    * @dev Get the baller price 
    * @return price of baller
    */
   function getBallerPrice() public view returns (uint) {
        return ballerFee;
    }
    
   /**
    * @dev Function for determining all the CryptoBallers owned by a specific address
    * @param _owner Address of owner
    * @return array of CryptoBallers owned by _owner
    */
    function getOwnedCryptoballers(address _owner) public view returns (uint[]) {
        return ownedBallers[_owner];
    }
   
   /**
    * @dev Helper function to get random Health Value between 0-10
    * @return random health value
    */
    function randomHealth() private view returns (uint) {
        uint randomHash = uint(keccak256(abi.encodePacked(block.difficulty, now)));
        return randomHash % 11;
    } 
      
}