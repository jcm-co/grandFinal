pragma solidity ^0.6.7;

// import to avoid underflow & overflow situation 
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0/contracts/utils/SafeCast.sol";
// import PriceConsumer contract to pay salary in USD
import "./PriceConsumerV3.sol";
// import CompanyToken contract to create your Company Token
import "./CompanyToken.sol";
// import ERC20 standard for the creation of your Company Token 
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0/contracts/token/ERC20/ERC20.sol";

// Data to test this project on Kovan Test Network

// Input #1 - (_employer, _ato, COMPANY_NAME, COMPANY_TICKER) "0xB698666265689e1c2C7eA12a054c47f281EbCe98","0xa2BCb92f0dD97363b506DAb75C703906997f9a38","RAJRAJ","RAJ"
// Input #2 "David JC","0x4A0514c470FeB8cB6ea55782850aeDB468C05535","100000","10","0x35dEf068c78b98bB49630A8e72FD22C19b89034f","USD","monthly","full-time"
// Input #3 "David Raj","0x143ccA60c3CB2b751a008b2Cad4C51B67c95baFe","100000","10","0x35dEf068c78b98bB49630A8e72FD22C19b89034f","USD","monthly","full-time"

// Data to test this project on local remix network

// employer address, ato address - "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2","0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c"
// import data "David Raj","0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db","100000","10","0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB","USD","monthly","full-time"
// import data "David JC","0xdD870fA1b7C4700F2BD7f44238821C26f7392148","100000","10","0x583031D1113aD414F02576BD6afaBfb302140225","USD","monthly","full-time"

contract SalaryProcessor{
    
    address payable employer_address;
    address payable ato_address;
    
    // Importing fx price via oracle (Chainlink). 
    // Code logic: declaring the variable that represents the EthUsd fX rate. (i) first you have to create a new variable, then that variable has to call the function
    PriceConsumerV3 latest_fx = new PriceConsumerV3();
 // @TODO coding line below needs to be commented out when testing on your local remix network. If running via Kovan network, you can uncomment it. 
//    int public EthUsd = latest_fx.getLatestPrice();
     
    //map in solidity is not loopable. So address array would be used to keep track of number of active employees.
    address payable[]  public arr_onboarded_employees; //@TODO make it private if deployed to customer on mainnet
    event Balance(uint balance);
    event SalaryEmit(uint salary);
    event TaxEmit(uint tax);
    event SuperEmit(uint super_amount);
    
    // Defining a structure which will serve as a list (python 'dictionary') to capture individual employee details
    struct EmployeeDetails { 
        string employee_name;
        uint employee_salary_gross;
        uint employee_salary_net;
        uint super_percentage;
        address payable super_address; 
        string preferred_currency;
        uint payment_frequency;
        string employee_type;
        uint onboarding_date;
        uint last_payment;
    }  
    
    
    // key is employee wallet address, using a mapping as an industry best practice to have quick search functionality (similar to a python dictionary)
    mapping(address => EmployeeDetails) public map_employee_details;
       CompanyToken token;
       
    constructor(address payable _employer, address payable _ato, string memory company_name, string memory company_ticker) payable public {
        employer_address = _employer;
        ato_address = _ato;
       // When running the contract, we also want to create a CompanyToken and set the supply at 0
        token = new CompanyToken(0, company_name, company_ticker); 
        // 
    }
    
    function stringToUint(string memory s) public returns (uint){
        bool hasError = false;
        bytes memory b = bytes(s);
        uint result = 0;
        uint oldResult = 0;
        for (uint i = 0; i < b.length; i++) { // c = b[i] was not needed
            if (uint8(b[i]) >= 48 && uint8(b[i]) <= 57) {
            // store old value so we can check for overflows
            oldResult = result;
            result = result * 10 + (uint8(b[i]) - 48); // bytes and int are not compatible with the operator -.
            // prevent overflows
            if(oldResult > result ) {
                // we can only get here if the result overflowed and is smaller than last stored value
                hasError = true;
                }
            } else {
                hasError = true;
            }
        }
        return (result);
    }

    function OnboardEmployee(string memory employee_name, address payable employee_address, string memory employee_salary_gross,
        string memory super_percentage, address payable super_address, string memory preferred_currency, string memory payment_frequency, string memory employee_type) public{
        EmployeeDetails memory ed = EmployeeDetails(employee_name, stringToUint(employee_salary_gross),0,10,super_address,preferred_currency,stringToUint(payment_frequency),employee_type,now,0);
        map_employee_details[employee_address] = ed;
        arr_onboarded_employees.push(employee_address);
    }   

    function OffboardEmployee(address employee_address) public {
        delete map_employee_details[employee_address];
        uint index_of_array_to_be_removed;
        for (uint i = 0; i<arr_onboarded_employees.length; i++){
            if (employee_address == arr_onboarded_employees[i]){
                index_of_array_to_be_removed = i; 
            }
        }
        for (uint i = index_of_array_to_be_removed; i<arr_onboarded_employees.length-1; i++){
            arr_onboarded_employees[i] = arr_onboarded_employees[i+1];
        }
        
    }

    // Calculate tax amount, withdraw from gross salary and transfer to ATO
    function Tax(address employee_address) public payable returns(uint) {
        uint tax;
        uint Salary = map_employee_details[employee_address].employee_salary_gross;
        if (Salary <= 18000) {tax = 0;}
        else if (Salary <= 45000) {tax = ((Salary - 18200) * 19 / 100);}
        else if (Salary <= 120000) {tax = ((Salary - 45001) * 325 / 1000 + 5092);}
        else if (Salary <= 180000) {tax = ((Salary - 120000) * 37 / 100 + 29467);}
        else if (Salary > 180000) {tax = ((Salary - 180001) * 45 / 100 + 51667);}
        return tax;
        
    }
    
    function Super(address employee_address) public payable returns(uint) {
        uint super_amount;
        uint salary = map_employee_details[employee_address].employee_salary_gross;
        // calculate super amount
        super_amount = (salary * map_employee_details[employee_address].super_percentage)/100;
        return super_amount;
        
    }
    
    // Loop through EmployeeDetails array and make all individual payments + define payment_frequency
     function PaySalary() public payable{
         EmployeeDetails memory ed;
         uint days_from_last_payment;
         uint tax_amount;
         uint super_amount;
         uint salary_to_be_credited;
         for(uint i = 0; i < arr_onboarded_employees.length;i++){
             ed = map_employee_details[arr_onboarded_employees[i]];
             //calculate how many days elapsed since last payment.
             if (ed.last_payment != 0)
             {
                 days_from_last_payment = (now - ed.onboarding_date)/ 60 / 60 / 24;
             }
             else 
             {
                 days_from_last_payment = (now - ed.last_payment)/ 60 / 60 / 24;
             }
             
             // Check if payment processing has to be done now
             if (days_from_last_payment >= ed.payment_frequency)
             {
                 tax_amount = (Tax(arr_onboarded_employees[i])/365)*ed.payment_frequency;
                 super_amount = (Super(arr_onboarded_employees[i])/365)*ed.payment_frequency;
                 salary_to_be_credited = ed.employee_salary_gross/365;
                 emit SalaryEmit(salary_to_be_credited);
                 uint net_salary_to_be_credited = (salary_to_be_credited*ed.payment_frequency) - tax_amount - super_amount;
                 emit SalaryEmit(net_salary_to_be_credited);
                 arr_onboarded_employees[i].transfer(salary_to_be_credited);
                 token.mint(arr_onboarded_employees[i],100);
                 emit TaxEmit(tax_amount);
                 ato_address.transfer(tax_amount);
                 emit SuperEmit(super_amount);
                 ed.super_address.transfer(super_amount);
                 emit Balance(ed.super_address.balance);
                 ed.last_payment = now;
             }
         }
     }
     function PayToAddress() public payable {
         ato_address.transfer(1);
     }
    
}
