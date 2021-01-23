const HDWalletProvider = require('truffle-hdwallet-provider-privkey');
// !!! Only put testing-purpose private keys !!!
const privateKey = "3e8d780a1356ffd6bbf2b7d12e5f6439b3fe3d1ede8bb957d011d6ddc09abd69";
const endpointUrl = "https://kovan.infura.io/v3/5fa7b7392de743468fa714d7dc54c258";

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "5777",
    },
    kovan: {
      provider: function() {
        return new HDWalletProvider(
            //private keys array
            [privateKey],
            //url to ethereum node
            endpointUrl
        )
      },
      gas: 5000000,
      gasPrice: 25000000000,
      network_id: 42
    }
  },
  // Configure your compilers
  compilers: {
    solc: {
      version: "0.7.0",    // Fetch exact version from solc-bin (default: truffle's version)
    }
  }
};