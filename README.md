# Lottery_vyper

This repo is the Vyper version of the [Lottery](https://github.com/PatrickAlphaC/smartcontract-lottery) from [Patrick Collins](https://github.com/PatrickAlphaC).
This code contain a Vyper implementation of the VRF random number from Chainlink.

Feel free to pull a request or an issue if you figure out how to improve the Vyper code.

# Instructions
- Before deploying the lottery, you need to deploy a VRF using ```brownie run scripts/deployVRF.py --network kovan```
- You need to fund LINK token to the VRF contract [Chainlink faucet](https://faucets.chain.link/kovan)
- Run the script using ```brownie run scripts/deployLottery.py --network kovan```

# Important note

You have to create your own .env file containing : 
```
export PRIVATE_KEY="YOUR_PRIVATE_KEY"
export WEB3_INFURA_PROJECT_ID="YOUR_INFURA_ID"
```

This code is mainly designed to be deployed on the Kovan testnet
