import {
  getClient,
  prepareSendTransaction,
  prepareWriteContract,
  readContract,
  sendTransaction,
  writeContract,
} from '@wagmi/core'
import { BigNumber, ethers } from 'ethers'
import { InputHTMLAttributes, useEffect, useRef, useState } from 'react'
import { useAccount } from 'wagmi'
import thePitIdl from '../contracts/ThePit.json'
import { downloadXlsx, getTokenIds } from '../utils'

interface nftStatus {
  id: number
  address: string
  status: number
  tokenStatus: number
  err?: string
}

const AssetsPage: React.FC = () => {
  const { isConnected, connector: activeConnector, address } = useAccount()
  const minSize = 1000
  const ids = getTokenIds(1, minSize)
  const inputRef = useRef<any>()
  // const [nftsId, setNftsId] = useState<number[]>([])
  const nftsIdRef = useRef<number[]>([])
  const [amount, setAmount] = useState('')
  const [nftsFormat, setNftsFormat] = useState<nftStatus[]>([])
  const [addressList, setAddressList] = useState<string[]>([])
  const [sending, setSending] = useState(false)
  useEffect(() => {
    getAssets()
    inputRef.current.addEventListener('change', selectedFileChanged)
  }, [])

  console.log('nftsId', nftsIdRef.current)
  console.log('nftsFormat', nftsFormat)
  const getAssets = async () => {
    console.log(thePitIdl.abi)
    // getClient()
    console.log(getTokenIds(1, 50))
    const result = await readContract({
      address: '0x83a80059cb677e366699c564f948183f323d61c4',
      abi: thePitIdl.abi,
      functionName: 'balanceOfBatch',
      args: [new Array(minSize).fill(address), ids],
    })
    console.log(result)
    const hasNft = (result as BigNumber[])
      .map((o, index) => ({
        id: index + 1,
        value: o,
      }))
      .filter((o) => (o.value as BigNumber).toString() === '1')
    nftsIdRef.current = hasNft.map((o) => o.id)
    setNftsFormat(
      nftsIdRef.current.map((id) => ({
        id,
        address: '',
        status: 0,
        tokenStatus: 0,
      }))
    )
  }

  const transfer = async () => {
    setSending(true)
    for (let i = 0; i < nftsFormat.length; i++) {
      let newNfts = [...nftsFormat]
      const nft = nftsFormat[i]
      if (nft.address && nft.id) {
        try {
          const config = await prepareWriteContract({
            address: '0x83a80059cb677e366699c564f948183f323d61c4',
            abi: thePitIdl.abi,
            functionName: 'safeTransferFrom',
            // args: [ from, to, id, amout, data],
            args: [
              address!,
              nft.address,
              ethers.utils.parseUnits(nft.id.toString(), 0),
              ethers.utils.parseUnits('1', 0),
              ethers.utils.toUtf8Bytes(nft.id.toString()),
            ],
          })
          console.log('config', config)
          const data = await writeContract(config)
          console.log('data', data)
          newNfts[i].status = 1
          setNftsFormat(newNfts)
        } catch (err: any) {
          newNfts[i].err = JSON.stringify(err.cause)
          setSending(false)
          setNftsFormat(newNfts)
        }
      } else {
        return { ...nft }
      }
    }
    setSending(false)
  }

  const transferToken = async () => {
    for (let i = 0; i < nftsFormat.length; i++) {
      const nft = nftsFormat[i]
      if(nft.address) {
        setSending(true)
        let newNfts = [...nftsFormat]
        try {
          const config = await prepareSendTransaction({
            request: {
              to: nftsFormat[i].address,
              value: ethers.utils.parseUnits(amount, 18),
            },
          })
          const { hash } = await sendTransaction({
            ...config,
          })
          setSending(false)
  
          newNfts[i].tokenStatus = 1
          console.log('hash', hash)
          setNftsFormat(newNfts)
        } catch (err: any) {
          newNfts[i].err = JSON.stringify(err.cause)
          setSending(false)
          setNftsFormat(newNfts)
        }
      }
     
    }
  }

  const selectedFileChanged = (e: any) => {
    console.log(e)
    if (inputRef.current.files.length === 0) {
      alert('请选择文件')
    }
    const reader = new FileReader()
    reader.onload = function fileReadCompleted() {
      // 当读取完成时，内容只在`reader.result`中
      console.log('result======', reader.result)
      const address = (reader.result as string).replace(/\r/g, '').split('\n')
      setAddressList(address)
      console.log(nftsIdRef.current)
      setNftsFormat(
        nftsIdRef.current.map((id, index) => ({
          id,
          address: address[index],
          status: 0,
          tokenStatus: 0,
        }))
      )
    }
    reader.readAsText(inputRef.current.files[0])
  }

  const exportExcel = () => {
    downloadXlsx(
      Object.keys(nftsFormat[0]),
      nftsFormat.map((o) => Object.values(o)),
      `转出表`
    )
  }

  return (
    <div style={{ paddingTop: 30 }}>
      <input type="file" ref={inputRef} />
      <span>数量:{nftsFormat.length}</span>
      <button style={{ marginLeft: 20 }} onClick={transfer}>
        批量转移NFT
      </button>
      <button style={{ marginLeft: 20 }} onClick={exportExcel}>
        导出
      </button>
      <div style={{ marginTop: 20 }}>
        <input type="text" onChange={(e) => setAmount(e.target.value)} />
        <button style={{ marginLeft: 20 }} onClick={transferToken}>
          批量转入Token
        </button>
      </div>
      <table className="nft-status">
        <thead>
          <tr>
            <th>NFT ID</th>
            <th>Transfer Address</th>
            <th>Status</th>
            <th>TokenStatus</th>
          </tr>
        </thead>
        <tbody>
          {nftsFormat.map((nft) => (
            <tr key={nft.id}>
              <td>{nft.id}</td>
              <td>{nft.address}</td>
              <td>{nft.status}</td>
              <td>{nft.tokenStatus}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}

export default AssetsPage
