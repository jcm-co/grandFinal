pragma solidity ^0.5.0;

//Do we need to do SafeMath? If so then import from OpenZeppelin and adjust -=+ etc

contract GrandFinalToken {
    address payable public owner = msg.sender;
    //sender is the employer
    string public symbol = "GFT";
    uint public exchange_rate = 1;
    //need to set exchange rate for how many tokens to employee per unit payment/bonus..

    mapping(address => uint) balances;
    // allows both employer and employee to see the balance of tokens

    function balance() public view returns(uint) {
        return balances[msg.sender];
        // returning balnace of employer/employee
    }

    function transfer(address recipient, uint value) public {
        balances[msg.sender] -= value;
        balances[recipient] += value;
    }

    //need to link the "purchase/gift" with the employees salary without taking payment for the tokens
    function purchase() public payable {
        uint amount = msg.value * exchange_rate;
        balances[msg.sender] += amount;
        owner.transfer(msg.value);
    }

    function mint(address recipient, uint value) public {
        require(msg.sender == owner, "You are not DE!");
        balances[recipient] += value;
    }
}
