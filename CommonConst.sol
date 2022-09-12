// contracts/GameItems.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract CommonConst is Initializable, OwnableUpgradeable {
    struct IngredientType {
        uint8 from;
        uint8 to;
        uint8[] tokenIds;
    }
    mapping(uint => IngredientType) private ingredientTypes;

    uint256 public constant typeCount = 5;
    uint256 public nonce;
    uint8[] private tokenIds1 = [1,2,3,4,5];
    uint8[] private tokenIds2 = [6,7,8];
    uint8[] private tokenIds3 = [9,10,11,12,13,14,15,16,17,18,19];
    uint8[] private tokenIds4 = [20,21,22,23,24];
    uint8[] private tokenIds5 = [25];

    function Initialize() external initializer  {
        __Ownable_init();
        ingredientTypes[1] = IngredientType({from:1,to:46, tokenIds:tokenIds1});
        ingredientTypes[2] = IngredientType({from:47,to:76, tokenIds:tokenIds2});
        ingredientTypes[3] = IngredientType({from:77,to:91, tokenIds:tokenIds3});
        ingredientTypes[4] = IngredientType({from:92,to:99, tokenIds:tokenIds4});
        ingredientTypes[5] = IngredientType({from:100,to:100, tokenIds:tokenIds5});
        nonce = 1;
    }

    function random(uint8 from, uint256 to) private returns (uint8) {
        uint256 randomnumber = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))) % to;
        randomnumber = from + randomnumber;
        nonce++;
        return uint8(randomnumber);
    }

    function setCategory(uint8 category,uint8 from, uint8 to, uint8[] memory tokenIds) external onlyOwner{
        require(category <= typeCount, "only 5 categories exist");
        require(from <= to, "Invalid range");
        ingredientTypes[category] = IngredientType({from:from,to:to,tokenIds:tokenIds});
    }


    function getIngredientNftId(uint8 category) private returns(uint){
        IngredientType memory ingredient = ingredientTypes[category];
        uint to = ingredient.tokenIds.length;
        uint num = random(1, to);
        return ingredient.tokenIds[num-1];
    }

    function getCategory(uint number) private view returns(uint8){
        uint8 index = 0;
        for(uint8 i = 1; i <= typeCount; i++) {
            if(number >= ingredientTypes[i].from &&  number <= ingredientTypes[i].to) {
                index = i;
            }
        }
        return index;
    }

    function getRandomIngredientId() external returns(uint256){
        uint8 number = random(1,100);
        uint8 category = getCategory(number);
        return getIngredientNftId(category);
    }

    function printCategory(uint8 category) external view returns(IngredientType memory){
        return ingredientTypes[category];
    }
}
