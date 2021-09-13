pragma solidity ^0.6.7;

// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Mintable.sol";


// contract CompanyToken is ERC20,ERCDetailed, ERC20Mintable {

//     address payable public owner = msg.sender;
//     //sender is the employer
//     string public symbol;
    
//     constructor(string memory name, string memory symbol, uint initial_supply) ERCDetailed(name, symbol, 18) public {
        
//          //CompanyToken, CT, 100000
         
//          mint(msg.sender,initial_supply);
        
//     }
// }

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0/contracts/token/ERC20/ERC20.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.0.0/contracts/token/ERC20/ERC20.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";

contract CompanyToken is ERC20 {
    address payable owner;
    modifier onlyOwner {
        require(msg.sender == owner);
        // and then run my function
        _;
    }
    // @TODO: Pass the required parameters to `ERC20Detailed`
    constructor(uint initial_supply, string memory company_name, string memory company_ticker) ERC20(company_name, company_ticker) public {
        // @TODO: Set the owner to be `msg.sender`
        owner = msg.sender;
        // @TODO: Call the internal `_mint` function to give `initial_supply` to the `owner`
        _mint(owner,initial_supply);
    }
    // @TODO: Add the `onlyOwner` modifier to this function after `public`
    function mint(address recipient, uint amount) public onlyOwner {
        // @TODO: Call the internal `_mint` function and pass the `recipient` and `amount` variables
        _mint(recipient,amount);
    }
}
