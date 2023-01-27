# Vote Delegate Descriptions

This project contains a contract that allows gov-alpha to set the decentralized storage file hash that stores the different delegate descriptions. 

It also allows delegates to set their own file hashes. 

It is meant to be indexed by the graph and to merge on-chain information of delegates with data stored on IPFS, Arweave or similar.

## Testing.

To launch the tests you need to add an ALCHEMY_API_KEY in the .env file. It will be used to fork mainnet and start different tests.

## Commands

- `yarn test` launches test suite
- `npx deploy` deploys contracts