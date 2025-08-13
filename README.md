Zenchain Testnet CoinFlip dApp
This is a minimal coin flip dApp for the Zenchain testnet (ZTC). It uses native chain currency for bets (msg.value).
note: Randomness in this contract is intentionally simple and NOT secure. Use this only on testnets for learning.
For production-grade randomness, integrate a VRF service (e.g., Chainlink VRF).

Zenchain Testnet info

- Chain ID: 8408 (0x20d8)
- RPC Endpoint (example): https://zenchain-testnet.api.onfinality.io/public
- Faucet: https://faucet.zenchain.io/

Deploying via Remix (quickest)

1. Open https://remix.ethereum.org/
2. Create a new file under 'contracts' and paste the contents of contracts/CoinFlip.sol
3. Compile with Solidity 0.8.17 (or compatible)
4. In 'Deploy & Run Transactions' tab:
   - Environment: Injected Web3 (this uses MetaMask)
   - Make sure MetaMask is set to Zenchain Testnet (add network using RPC & Chain ID above)
   - Deploy contract with constructor param: minBet in wei (e.g., for 0.01 ZTC -> 0.01 \* 1e18 = 10000000000000000) but it is set to 5 ztc
     Example: 10000000000000000
5. Confirm transaction in MetaMask and wait for deployment.
6. Copy the deployed contract address and replace the placeholder in frontend/index.html (REPLACE_WITH_DEPLOYED_CONTRACT_ADDRESS)
