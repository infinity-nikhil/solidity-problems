## A guide to how to create your smart contract frontend 

We are using ether js library, the docs are not so much clear this far so i am just
coding how it'done from third party docs and library.....

### the connect wallet button
```typescript
  const [address, setAddress] = useState("");
  async function connectWallet() {
    if(!window.ethereum) {
      alert("Metamask Not installed");
    }

    const addresses = await window.ethereum.request({
      method: "eth_requestAccounts",
    });
    const provider = new ethers.BrowserProvider(window.ethereum);
    const signer = await provider.getSigner();
    const contractAddrr = "0x5FbDB2315678afecb367f032d93F642f64180aa3";

    const contract = new ethers.Contract(contractAddrr, abi, signer);
    console.log("Contract: ", contract);
    setAddress(addresses[0]);
  }
```
as far as we know we are clearly aware of proviedr, signer and contract instance....and in ts you can show the address of the wallet conneted.....and the then with the help of contract instance we print our contract as an Object......

### If we only want to know the core connect wallet logic not the contract 
We can find it in metamask wallet docs i guess...
```typescript
  const [address, setAddress] = useState("");
  async function connectWallet() {
    if(!window.ethereum) {
      alert("Metamask Not installed");
    }

    //this is the msin logic ...coming from metamask docs i guess //////////
    const addresses = await window.ethereum.request({
      method: "eth_requestAccounts",
    });
    ///////////////////////////////////////////////////////////////////

    setAddress(addresses[0]);
  }
```
as you can see don't need provider signer for wallet connect and read the address....those of for doing read and write operation on blockchain..........