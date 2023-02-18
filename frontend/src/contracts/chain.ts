import {  Chain } from "wagmi";

export const scrollChain: Chain = {
  id: 534354,
  name: 'Scroll L2 Testnet',
  network: 'scrollL2Testnet',
  nativeCurrency: { name: 'Scroll L2 Ether', symbol: 'TSETH', decimals: 18 },
  rpcUrls: {
    // alchemy: alchemyRpcUrls.goerli,
    // infura: infuraRpcUrls.goerli,
    default: {http: ['https://prealpha.scroll.io/l2']},
  },
  // blockExplorers: {
  //   etherscan: ,
  //   default: etherscanBlockExplorers.goerli,
  // },
  // ens: {
  //   address: '0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e',
  // },
  // multicall: {
  //   address: '0x699CE1B15A07d3cda509CF25b836fE66AACc6590',
  //   blockCreated: 6507670,
  // },
  testnet: true,
}


export const polygonTestChain: Chain = {
  id: 80001,
  name: 'Mumbai Testnet',
  network: 'MumbaiTestnet',
  nativeCurrency: { name: 'Mumbai Testnet', symbol: 'MATIC', decimals: 18 },
  rpcUrls: {
    default: {http: ['https://rpc-mumbai.maticvigil.com']},
  },
  // blockExplorers: {
  //   etherscan: etherscanBlockExplorers.polygon,
  //   default: etherscanBlockExplorers.polygon,
  // },
  // ens: {
  //   address: '0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e',
  // },
  // multicall: {
  //   address: '0x699CE1B15A07d3cda509CF25b836fE66AACc6590',
  //   blockCreated: 6507670,
  // },
  testnet: true,
}


export const contractsAddress  = {
  localhost: '0x5fbdb2315678afecb367f032d93f642f64180aa3',
  scroll: '0x699CE1B15A07d3cda509CF25b836fE66AACc6590',
  polygon: '0x699ce1b15a07d3cda509cf25b836fe66aacc6590',
}