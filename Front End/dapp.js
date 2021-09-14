// @TODO: Update this address to match your deployed MartianMarket contract!
const contractAddress = "0x7a377fAd8c7dB341e662c93A79d0B0319DD3DaE8";

const dApp = {
  ethEnabled: function() {
    // If the browser has an Ethereum provider (MetaMask) installed
    if (window.ethereum) {
      window.web3 = new Web3(window.ethereum);
      window.ethereum.enable();
      return true;
    }
    return false;
  },
  getInputValue: async function() {
    localStorage.setItem('inputEmployeeAddress', document.getElementById("dapp-employee-address").value);
    localStorage.setItem('inputEmployeeName', document.getElementById("dapp-employee-name").value);
    localStorage.setItem('inputEmployeeGrossSal', document.getElementById("employee-gross-sal").value);
    localStorage.setItem('inputSuperPercentage', document.getElementById("super-percentage").value);
    localStorage.setItem('inputSuperAddress', document.getElementById("super-address").value);
    localStorage.setItem('inputPreferredCurrency', document.getElementById("preferred-currency").value);
    localStorage.setItem('inputPaymentFrequency', document.getElementById("payment-frequency").value);
    localStorage.setItem('inputEmployeeType', document.getElementById("employee-type").value);
  },
  main: async function() {
    // Initialize web3
    if (!this.ethEnabled()) {
      alert("Please install MetaMask to use this dApp!");
    }

    this.accounts = await window.web3.eth.getAccounts();
    this.contractAddress = contractAddress;
    var inputEmployeeAddress = localStorage.getItem('inputEmployeeAddress', document.getElementById("dapp-employee-address").value);
    var inputEmployeeName = localStorage.getItem('inputEmployeeName', document.getElementById("dapp-employee-name").value);
    var inputEmployeeGrossSal = localStorage.getItem('inputEmployeeGrossSal', document.getElementById("employee-gross-sal").value);
    var inputSuperPercentage = localStorage.getItem('inputSuperPercentage', document.getElementById("super-percentage").value);
    var inputSuperAddress = localStorage.getItem('inputSuperAddress', document.getElementById("super-address").value);
    var inputPreferredCurrency = localStorage.getItem('inputPreferredCurrency', document.getElementById("preferred-currency").value);
    var inputPaymentFrequency = localStorage.getItem('inputPaymentFrequency', document.getElementById("payment-frequency").value);
    var inputEmployeeType = localStorage.getItem('inputEmployeeType', document.getElementById("employee-type").value);
    this.SalaryProcessorJson = await (await fetch("./SalaryProcessor.json")).json(); 
    this.PriceConsumerV3Json = await (await fetch("./PriceConsumer.json")).json();
    this.CompanyTokenJson = await (await fetch("./CompanyToken.json")).json();

    //Invoke the constructor
    this.marsContract = new window.web3.eth.Contract(
      this.SalaryProcessorJson,
      this.contractAddress,
      { defaultAccount: this.accounts[0] }
    );
    //Once object created successfully
    //call onboarding function with all the above parameters
    //Call paySalary function to trigger payment

    console.log("Contract object", this.SalaryProcessorJson);
   
  }
};

dApp.main();
