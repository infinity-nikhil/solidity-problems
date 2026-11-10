## Wallet connect done..now read Contract done...now writing on to the contract...
The steps are the same here:
-> Connect the wallet
-> get the signer, provider and the contract Instance....

So surprisingly writing the contract is the simple thing too....
i don't know but for know it is working as simple call like:
```typescript
  async function setNum() {
    const tx = await contract.setNumber(56);
    console.log(tx);
  }
```
yupp this is the write operation and all that is ....
one thing make sure to be on anvil or will have error and the  request will most likely fail