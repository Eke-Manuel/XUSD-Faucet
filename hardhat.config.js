require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "Mumbai",
  networks: {
    hardhat: {
    },
    Mumbai: {
      url: process.env.MUMBAI_URL,
      accounts: {
        mnemonic: [ process.env.MNEMONIC ]
      }
    }
  },
  solidity: {
    version: "0.8.10",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    },
  },
  etherscan: {
    apiKey: process.env.API_KEY,
 },
  mocha: {
    timeout: 40000
  }
}
