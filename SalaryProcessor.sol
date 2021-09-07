pragma solidity ^0.5.0;

// restrict a function so it can only be used by owner of the contract
//import "./Ownable.sol";
//https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/utils/SafeCast.sol";

// employer address, ato address - "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2","0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c"
// import data "David Raj","0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db","100000","10","0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB","USD","monthly","full-time"
// import data "David JC","0xdD870fA1b7C4700F2BD7f44238821C26f7392148","100000","10","0x583031D1113aD414F02576BD6afaBfb302140225","USD","monthly","full-time"

// employee Address "0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c"

contract SalaryProcessor{
    
    address payable employer_address;
    address payable ato_address;
    //map in solidity is not loopable. So address array would be used to keep track of number of active employees.
    address payable[]  public arr_onboarded_employees; //@TODO make it private after unit testing.
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
       
    // @TODO update constructor
    constructor(address payable _employer, address payable _ato) payable public {
        employer_address = _employer;
        ato_address = _ato;
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

    
    // @TODO update function to capture EmployeeDetails & add to array of structures 
    function OnboardEmployee(string memory employee_name, address payable employee_address, string memory employee_salary_gross,
        string memory super_percentage, address payable super_address, string memory preferred_currency, string memory payment_frequency, string memory employee_type) public{
        EmployeeDetails memory ed = EmployeeDetails(employee_name, stringToUint(employee_salary_gross),0,10,super_address,preferred_currency,stringToUint(payment_frequency),employee_type,now,0);
        map_employee_details[employee_address] = ed;
        arr_onboarded_employees.push(employee_address);
    }   
    
    // @TODO update array of structures by removing EmployeeDetails 
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
        arr_onboarded_employees.length--;
        
    }

    // @TODO calculate if a bonus or comission is applicable 
    // function CalculateBonus(){}

    // Calculate tax amount, withdraw from gross salary and transfer to ATO
    function Tax(address employee_address) public payable returns(uint) {
        uint tax;
        uint Salary = map_employee_details[employee_address].employee_salary_gross;
        // @TODO - calculate tax amount - function implies a simplistic tax percentage (further if statements to be added to define percentages)
        if (Salary <= 18000) {tax = 0;}
        else if (Salary <= 45000) {tax = ((Salary - 18200) * 19 / 100);}
        else if (Salary <= 120000) {tax = ((Salary - 45001) * 325 / 1000 + 5092);}
        else if (Salary <= 180000) {tax = ((Salary - 120000) * 37 / 100 + 29467);}
        else if (Salary > 180000) {tax = ((Salary - 180001) * 45 / 100 + 51667);}
    
        // send amount to ATO
        //ato_address.transfer(tax);
        return tax;
        
    }
    
 // @TODO calculate super_amount based on super_percentage + transfer to super_address
    function Super(address employee_address) public payable returns(uint) {
        uint super_amount;
        uint salary = map_employee_details[employee_address].employee_salary_gross;
        // calculate super amount
        super_amount = (salary * map_employee_details[employee_address].super_percentage)/100;
        // send super amount to super company
        return super_amount;
        
    }
    
    // @TODO loop through EmployeeDetails array and make all individual payments + define payment_frequency
     function PaySalary() public payable{
         EmployeeDetails memory ed;
         uint days_from_last_payment;
         uint tax_amount;
         uint super_amount;
         uint salary_to_be_credited;
         for(uint i = 0; i < arr_onboarded_employees.length;i++){
             ed = map_employee_details[arr_onboarded_employees[i]];
             //calculate how many days elapsed from last payment.
             if (ed.last_payment != 0)
             {
                 days_from_last_payment = (now - ed.onboarding_date)/ 60 / 60 / 24;
             }
             else 
             {
                 days_from_last_payment = (now - ed.last_payment)/ 60 / 60 / 24;
             }
             
             //Check if payment processing to be done now
             if (days_from_last_payment >= ed.payment_frequency)
             {
                 tax_amount = (Tax(arr_onboarded_employees[i])/365)*15;
                 super_amount = (Super(arr_onboarded_employees[i])/365)*15;
                 salary_to_be_credited = ed.employee_salary_gross/365;
                 emit SalaryEmit(salary_to_be_credited);
                 uint net_salary_to_be_credited = (salary_to_be_credited*15) - tax_amount - super_amount;
                 emit SalaryEmit(net_salary_to_be_credited);
                 arr_onboarded_employees[i].transfer(salary_to_be_credited);
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

    
    // @TODO convert initial salary to preferred payout currency + include Oracle Chainlink to add currency rate 
    // function ConvertPreferredCurrency(){}
    
//   // @TODO loop through EmployeeDetails array and make all individual payments + define payment_frequency
//     function PaySalary() public {
//         uint NetSalary;
//         // update pay timestamp     
//         // define net salary
//         NetSalary = EmployeeDetails.employee_salary_gross - Tax();
//         employer_address.transfer(NetSalary);
//     }
    
    
    // possible features of the contract - to be created afterwards
    // function AnnualSalaryReview() - function to evaluate salary based on inflation or market environment 

    // @TODO calculate tenure of an employee for Token calculation 
    // function CalculateTenure() 
    
    // @TODO calculate payment_frequency based on employee_type (eg. employee is based in USA therefore needs fortnightly payments)
    
    
}
