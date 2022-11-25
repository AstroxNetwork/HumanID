PRIVATE_KEY='0x'
SCROLL_TESTNET_URL='https://prealpha.scroll.io/l2'
POLYGON_URL='https://polygon-rpc.com'

require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  settings: {
    optimizer: {
      enabled: true,
      runs: 200,
    },
  },
  networks: {
  	scrollTestnet: {
      url: SCROLL_TESTNET_URL,
      accounts: [PRIVATE_KEY]
    },
    polygon: {
      url: POLYGON_URL,
      accounts: [PRIVATE_KEY]
    },
    hardhat: {
      accounts: [
        {
          privateKey: '0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80',
          balance: '10000000000000000000000'
        },
        {
          privateKey: '0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a',
          balance: '10000000000000000000000'
        }
      ]
    }
  }
};
