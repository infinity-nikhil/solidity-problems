## Previously we saw how can connect the wallet..
Will research and go to the core working of wallet and docs of metamask sometime else.....

### How to perform read operation on contract....
STEPS:
-> connect the wallet 
-> get the provider 
-> get the signer 
-> get the contract Instance with the help of the abi and the contract address
-> set the contract in a global useState var as setContrat 

EXTRAS:
(also in ts learned how to assign random object in use State by the use if any -> ```useState<any | null>(null);``` no paranthesis on useState), its is used when you are fetching the data from the abi and you don't know the structure of the object. 

and the rest is simple just call the public/state variable declared in contract using the contract instance and parse it in a variable
reading a simple function
```typescript
async function getNumber() {
    const data = await contract.getNum(); //getNum a simple function in contract to return a uint256 var
    console.log(data);
}
```
reading a state variable 
```typescript
async function getOwner() {
    const data = await contract.owner(); //solidity converts the public var into a getter funciton by default
    console.log(data);
}
```