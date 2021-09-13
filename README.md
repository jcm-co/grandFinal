# The Grand Final

As a final project of the FinTech bootcamp, our team has developed a new way of managing your payroll. 
By leveraging Smart Contracts technology you can now easily process your corporate payroll in a fast & secure manner. 
Our team can create a bespoke environment for your company to accommodate for loalized tax schemes, bonus structures, share structures, benefits,... 

For this product we've chosen to leverage a Minimum Viable Product, with a number of product improvements mentioned in this document. 
It is our objective to add these features in the near future. 

# Tools

* [Remix Ethereum](http://remix.ethereum.org/)
* MetaMask
* Ganache _(you can create a test wallet here, get some ethereum in your test wallet [here](https://faucet.ropsten.be/)._

## Technical Setup 

In order to get started, ensure you're set up on the test network Kovan. 
If you're looking to export this to your business, please contact us at info@grandfinal.io
Our team of experts will be available to get you started on the Ethereum Mainnet. 

## Business opportunity 
* Speed - instant payment cross border
* Flexibility of payment for the employee
* Security - on the Ethereum blockchain
* Transparency of salaries for larger companies
* Lower cost vs classic payment - no middleman fees
* Less administrative overhead costs
* Efficient payment of Taxes and Superannuation within the contract

Token at the centre of your company's universe 

Product improvement: Employee can pick their remuneration package based on X amount of company tokens  



### Step 1 - Create your company Token

_This step is optional however we strongly suggest to get started with your bespoke company token._
A first step is to create your Company Token, this is done through an Initial Coin Offering (ICO). 
This is the equivalent of company shares. At this point no action is required however it creates plenty of possibiilites for the future. 
Think about giving your employees a stake of your company or even paying their salaries in your Company Token. Another possibility is to offer investors to buy themselves in to your company. The sky is the limit. 

Creating your token is done by executing the CompanyToken.sol file, in which you can set the parameters of your Token. 
For this you need to access [Remix Ethereum](http://remix.ethereum.org/) with a compiler of > 0.6.7. 


### Step 2 - Onboard your employee(s)

Onboard your employee(s) & their personalized information through the onboarding process. 
The process can be customized, for now it includes basic inputs such as: wallet address, super address, ato address,... 

_Potential iteration to the tool >> upload a csv file with bulk data_ 

![Onboarding](Onboarding.png)





### Step 3 - Process payments 

### Possible iterations 
1. Oracle to dynamicly insert other fiat currencies - _currently we only support ETH/USD, of which the value is *not* in real time._
2. 



## Contributing
Thanks to the help of Claudia and Liam for troubleshooting the contract!
