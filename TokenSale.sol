pragma solidity ^0.6.7;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Mintable.sol";


contract GrandFinalToken is ERC20,ERCDetailed, ERC20Mintable {

    address payable public owner = msg.sender;
    //sender is the employer
    string public symbol;
    
    constructor(string memory name, string memory symbol, uint initial_supply) ERCDetailed(name, symbol, 18) public {
        
         //ArcadeToken, ARCD, 100000
         
         mint(msg.sender,initial_supply);
        
    }
}
