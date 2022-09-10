// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol"; //
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/utils/ERC721HolderUpgradeable.sol";//
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol"; //

interface IBossCardERC1155{
    function safeTransferFrom(address from, address to, uint id, uint amount, bytes memory data) external;
}

interface IIngredientsERC1155{
    function safeTransferFrom(address from, address to, uint id, uint amount, bytes memory data) external;
    function mint(address to, uint256 id, uint256 value) external returns(address);
}

contract Errand is Initializable,ERC721HolderUpgradeable, ReentrancyGuardUpgradeable, OwnableUpgradeable,UUPSUpgradeable{

        IERC721Upgradeable private powerPlinsGen0;
    address private bossCardERC1155;
    address private ingredientsERC1155;

    uint256 public stakeIdCount;
    uint256  public _timeForReward;

    uint public nonce ;
    uint public typeCount;

    
    struct BossCardStaker{
        uint tokenId;
        bool isLegendary;
        uint256  time;
    }
    mapping(address => BossCardStaker)  public bossCardStakers;

    struct RecipeStaker {
        uint256 stakeId;
        uint[] tokenIds;
        uint256  time;
    }

    mapping(address => RecipeStaker[]) public recipeStakers;
    mapping(address => mapping(uint256 => uint256))  tokenIdToRewardsClaimed;

    function findIndex(uint value) internal view returns(uint) {
        uint i = 0;
        RecipeStaker[] memory stakers = recipeStakers[msg.sender];
        while (stakers[i].stakeId != value) {
            i++;
        }
        return i;
    }
    //for critical warning 3
/// @custom:oz-upgrades-unsafe-allow constructor
constructor() {
    _disableInitializers();
}

function initialize(address _powerPlinsGen0, address _ingredientsERC1155,address _bossCard) external initializer {
                powerPlinsGen0 = IERC721Upgradeable(_powerPlinsGen0);
        ingredientsERC1155 = _ingredientsERC1155;
        bossCardERC1155 = _bossCard;
        stakeIdCount = 1;
        _timeForReward = 60;
        nonce = 1;
        typeCount = 5;
        __Ownable_init();
        __UUPSUpgradeable_init();
        __ERC721Holder_init();
        __ReentrancyGuard_init() ;




}






    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}


}
