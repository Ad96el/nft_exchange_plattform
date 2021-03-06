module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7546,
      network_id: "5777" // Match any network id
    },
  },
  // contracts_directory: './src/contracts/',
  // contracts_build_directory: './src/abis/',
  compilers: {
    solc: {
      version: "0.6.2",
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
}
