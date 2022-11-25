import React from 'react'
import ReactDOM from 'react-dom/client'
import '@rainbow-me/rainbowkit/styles.css'
import { RainbowKitProvider, getDefaultWallets } from '@rainbow-me/rainbowkit'
import { chain, configureChains, createClient, WagmiConfig } from 'wagmi'
import { jsonRpcProvider } from 'wagmi/providers/jsonRpc'
import App from './App'
import './index.css'
import { polygonTestChain, scrollChain } from './contracts/chain'

const chains =
  import.meta.env.MODE === 'development'
    ? [chain.localhost, scrollChain, polygonTestChain]
    : [scrollChain, polygonTestChain]
const { provider, webSocketProvider } = configureChains(chains, [
  jsonRpcProvider({
    rpc: (chain) => {
      return {
        http:
        chain.rpcUrls.default
      }
    },
  }),
])
const { connectors } = getDefaultWallets({
  appName: 'Challenge',
  chains,
})

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
