import { useEffect, useRef, useState } from 'react'
import { ConnectButton } from '@rainbow-me/rainbowkit'
import { useAccount, useContractRead, useNetwork } from 'wagmi'
import qs from 'querystring'
import { QRCodeSVG } from 'qrcode.react'
import './App.less'
import { getContract, readContract } from '@wagmi/core'
import { Modal, Toast } from './component'
import { ModalShowHandler } from './component/components/modal/show'
import popIdl from './contracts/POP.json'
import { contractsAddress } from './contracts/chain'

let verifyTimer: string | number | NodeJS.Timeout | undefined

function App() {
  const [verified, setVerified] = useState(false)
  const { isConnected, connector: activeConnector, address } = useAccount()
  const { chain } = useNetwork()
  const modalRef = useRef<ModalShowHandler>()
  const prefix = 'astrox://human?'
  const params = {
    address,
    host: window.location.hostname,
  }
  console.log(chain)
  const contractAddress =
    chain?.id === 80001
      ? contractsAddress.polygon
      : chain?.id === 534354
      ? contractsAddress.scroll
      : contractsAddress.localhost
  const scope = prefix + qs.stringify(params)
  const { data, isError, isLoading } = useContractRead({
    address: contractAddress,
    abi: popIdl.abi,
    functionName: 'get_token',
    args: [scope, address!],
    onSuccess: (data) => {
      const verified =
      (data as any)?.user === address &&
      (data as any)?.scope === scope
      setVerified(verified)
    }
  })
  console.log('contractAddress',contractAddress)
  console.log('data', data)
  console.log('verified', verified)

  useEffect(() => {
    return () => {
      clearInterval(verifyTimer)
    }
  }, [])

  const verifyModal = () => {
    modalRef.current = Modal.show({
      closeOnMaskClick: true,
      content: (
        <div style={{ padding: 20 }}>
          <h2 style={{ marginBottom: 10 }}>Scan with HumanID App</h2>
          <div
            style={{
              overflow: 'hidden',
              borderRadius: 10,
              cursor: 'pointer',
              fontSize: 0,
              margin: '0 auto',
              width: 200,
              height: 200,
            }}
          >
            <QRCodeSVG value={scope} size={200} includeMargin />
          </div>
        </div>
      ),
      onClose: () => {
        clearInterval(verifyTimer)
      },
    })
    verifyTimer = setInterval(async () => {
      if (await getTokenIsVerified()) {
        setVerified(true)
        modalRef.current?.close()
        Toast.show('verified.')
      }
    }, 2000)
  }

  const getTokenIsVerified = async () => {
    const data = await readContract({
      address: contractAddress,
      abi: popIdl.abi,
      functionName: 'get_token',
      args: [scope, address!],
    })
    console.log(data)
    console.log(typeof (data as any)?.created_at)
    const verified =
      (data as any)?.user === address &&
      (data as any)?.scope === scope
    return verified
  }

  return (
    <>
      <div className="app">
        <h1>HumanID example</h1>
        <div style={{ display: 'flex', justifyContent: 'space-between' }}>
          <ConnectButton />
          <a href="https://astroxmehk.s3.ap-east-1.amazonaws.com/humanId-hackathon-v1.apk">
            <button>Download HumanID App</button>
          </a>
        </div>
        {isConnected ? (
          <div>
            <p>Address:{address}</p>
            {verified ? (
              <>
                <p>verified.</p>
              </>
            ) : (
              <>
                <button onClick={verifyModal}>Go verify</button>
              </>
            )}
          </div>
        ) : null}
      </div>
      <p className="read-the-docs">AstroX© 2022</p>
    </>
  )
}

export default App
