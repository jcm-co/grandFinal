pragma solidity ^0.6.7;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0/contracts/token/ERC20/ERC20.sol";

contract CompanyToken is ERC20 {
    address payable owner;
    modifier onlyOwner {
        require(msg.sender == owner);
        // and then run my function
        _;
    }
    
    constructor(uint initial_supply, string memory company_name, string memory company_ticker) ERC20(company_name, company_ticker) public {
        owner = msg.sender;
        _mint(owner,initial_supply);
    }
    // @TODO: Add the `onlyOwner` modifier to this function after `public`
    function mint(address recipient, uint amount) public onlyOwner {
        // @TODO: Call the internal `_mint` function and pass the `recipient` and `amount` variables
        _mint(recipient,amount);
    }
}
