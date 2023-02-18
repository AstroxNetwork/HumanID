import React from 'react'
import ReactDOM from 'react-dom/client'
import '@rainbow-me/rainbowkit/styles.css'
import { RainbowKitProvider, getDefaultWallets, connectorsForWallets,  } from '@rainbow-me/rainbowkit'
import {
  metaMaskWallet,
} from '@rainbow-me/rainbowkit/wallets';
import { configureChains, createClient, WagmiConfig } from 'wagmi'
import * as chain from 'wagmi/chains';
import { jsonRpcProvider } from 'wagmi/providers/jsonRpc'
import App from './App'
import './index.css'
import { polygonTestChain, scrollChain } from './contracts/chain'

const chains =
  import.meta.env.MODE === 'development'
    ? [chain.localhost, scrollChain]
    : [scrollChain, polygonTestChain, chain.polygon]
const { provider, webSocketProvider } = configureChains(chains, [
  jsonRpcProvider({
    rpc: (chain) => {
      console.log(chain)
      return {
        http:
        chain.rpcUrls.default.http[0]
      }
    },
  }),
])
// const { connectors } = getDefaultWallets({
//   appName: 'Challenge',
//   chains,
// })
console.log('provider======', provider)
const connectors = connectorsForWallets([
  {
    groupName: 'Recommended',
    wallets: [
      metaMaskWallet({ chains }),
    ],
  },
]);

const wagmiClient = createClient({
  autoConnect: true,
  connectors,
  provider,
  webSocketProvider,
})

ReactDOM.createRoot(document.getElementById('root') as HTMLElement).render(
  <React.StrictMode>
    <WagmiConfig client={wagmiClient}>
      <RainbowKitProvider chains={chains}>
        <div className="container">
          <App />
        </div>
      </RainbowKitProvider>
    </WagmiConfig>
  </React.StrictMode>
)
