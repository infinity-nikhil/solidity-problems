# Reading the contract via frontend

This repo is a learning reference for how to **read** on-chain data from a smart 
contract using a frontend. Reading is free and doesn't need a wallet signature — 
it's just querying the blockchain's current state, similar to a GET request.

**Tech stack:** Wagmi + TanStack Query + viem + RainbowKit

> For wallet connection setup, see the earlier repo where I covered the different 
> ways to connect a wallet with RainbowKit.

## How it works, conceptually

- Wagmi hooks are built on **TanStack Query** under the hood, so you get caching, 
  refetching, and loading/error states for free.
- **viem** is the low-level library that actually encodes the function call and 
  decodes the returned bytes into JS types, using your ABI.
- **RainbowKit** only handles wallet connection/UI — reading contract data doesn't 
  require a connected wallet at all, since it's a public RPC call.

## Steps

1. **Deploy the contract** (or use an existing one) and note its address and the 
   network it's deployed on.
2. **Get the ABI.** Compile the contract (e.g. with Foundry) and copy the `abi` 
   array from the output JSON into a local `abi.ts` file. Add `as const` so 
   TypeScript can infer exact function names and argument/return types.
3. **Set the contract address** as an env variable 
   (`NEXT_PUBLIC_CONTRACT_ADDRESS`) so it's not hardcoded, and restart the dev 
   server after adding/changing it.
4. **Configure the chain** in `wagmi.ts` (e.g. `sepolia`) so the app and the 
   wallet agree on which network to talk to.
5. **Write a custom hook** wrapping `useReadContract`, passing the `abi`, 
   `address`, `functionName`, and `chainId`. Passing `chainId` explicitly makes 
   the read always target the right network, regardless of what network the 
   connected wallet happens to be on.
6. **Call the hook** from a page/component. It returns `data`, `isLoading`, 
   `error`, and a `refetch` function, exactly like a TanStack Query hook, because 
   it is one.

## Code snippets

### `hooks/useContracts.ts`

```typescript
import { sepolia } from "wagmi/chains";
import { ABI } from "../abi";
import { useReadContract } from "wagmi";

const contractAddress = process.env.NEXT_PUBLIC_CONTRACT_ADDRESS as `0x${string}`;

export function useCount() {
  return useReadContract({
    abi: ABI,
    address: contractAddress,
    functionName: "count",
    chainId: sepolia.id,
  });
}
```

### Calling it on the main page

```tsx
import { useCount } from "../hooks/useContracts";

const Home = () => {
  const { data: count, isLoading, error, refetch } = useCount();

  if (isLoading) return <p>Loading...</p>;
  if (error) return <p>Error: {error.message}</p>;

  return (
    <div>
      {/* count is a bigint — convert before rendering */}
      <p>Count: {count?.toString()}</p>
      <button onClick={() => refetch()}>Refresh</button>
    </div>
  );
};

export default Home;
```

## Notes / gotchas

- `uint256` return values come back as JS `bigint`. React can't render a 
  `bigint` directly, so always convert with `.toString()`, `Number()` (safe only 
  for small values), or viem's `formatUnits` for token amounts with decimals.
- No wallet connection is required for `useReadContract` to work — it queries 
  the RPC directly. Wallet connection only matters for the **write** side 
  (sending transactions).
- `data` is `undefined` on the first render before the RPC responds — always 
  guard against that (`count?.toString()`, not `count.toString()`).
- If `functionName` takes arguments, pass them via the `args` array, e.g. 
  `args: [someAddress]`.