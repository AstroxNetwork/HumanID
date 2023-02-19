import { prepareWriteContract, readContract, writeContract } from "@wagmi/core";
import { BigNumber, ethers } from "ethers";
import { InputHTMLAttributes, useEffect, useRef, useState } from "react";
import { useAccount } from "wagmi";
import thePitIdl from '../contracts/ThePit.json'
import { downloadXlsx, getTokenIds } from "../utils";

interface nftStatus {
  id: number;
  address: string;
  status: number;
  err?: string;
}

const AssetsPage: React.FC = () => {
  const { isConnected, connector: activeConnector, address } = useAccount()
  const minSize = 50;
  const ids = getTokenIds(1, minSize)
  const inputRef = useRef<any>()
  // const [nftsId, setNftsId] = useState<number[]>([])
  const nftsIdRef = useRef<number[]>([])
  const [nftsFormat, setNftsFormat] = useState<nftStatus[]>([])
  const [addressList, setAddressList] = useState<string[]>([])
  useEffect(() => {
    getAssets()
    inputRef.current.addEventListener('change', selectedFileChanged
    );
  }, [])

  console.log('nftsId',nftsIdRef.current)
  console.log('nftsFormat',nftsFormat)
  const getAssets = async () => {
    console.log(thePitIdl.abi)
    console.log(getTokenIds(1, 50))
    // const result = await Promise.all(ids.map( async (id) => {
    //   const data =  await readContract({
    //     address: '0xF8c761ccB8459cA802a30B408ea53F07Cb4B2075',
    //     abi: thePitIdl.abi,
    //     functionName: 'balanceOf',
    //     args: [ address!, id],
    //   })
    //   return {
    //     id,
    //     value: data,
    //   }
    // }))
    // console.log(result)
    const result =  await readContract({
      address: '0xF8c761ccB8459cA802a30B408ea53F07Cb4B2075',
      abi: thePitIdl.abi,
      functionName: "balanceOfBatch",
      args: [ new Array(minSize).fill(address), ids],
    })
    console.log(result)
    const hasNft = (result as BigNumber[]).map((o, index) => ({
      id: index + 1,
      value: o,
    })).filter(o => (o.value as BigNumber).toString() === '1');
    nftsIdRef.current = hasNft.map(o => o.id)
    setNftsFormat(nftsIdRef.current.map(id => ({
      id,
      address: '',
      status: 0
    })))
  }


  const transfer = async () => {
    const result = await Promise.all(nftsFormat.map( async nft => {
        try {
          const config = await prepareWriteContract({
            address: '0xF8c761ccB8459cA802a30B408ea53F07Cb4B2075',
            abi: thePitIdl.abi,
            functionName: "safeTransferFrom",
            // args: [ from, to, id, amout, data],
            args: [ address!, nft.address, ethers.utils.parseUnits(nft.id.toString(), 0), ethers.utils.parseUnits('1', 0), ethers.utils.toUtf8Bytes(nft.id.toString())],
          })
          console.log('config',config)
          const data = await writeContract(config)
          console.log('data', data)
          return {
            ...nft,
            status: 1,
            err: ''
          }
        } catch(err: any) {
          return {
            ...nft,
            status: 0,
            err: err
          }
        }
      }))
      console.log(result)
    setNftsFormat(result)
  }

  const selectedFileChanged = (e: any) => {
    console.log(e)
    if(inputRef.current.files.length === 0) {
      alert('请选择文件')
    }
    const reader = new FileReader();
    reader.onload = function fileReadCompleted() {
      // 当读取完成时，内容只在`reader.result`中
      console.log('result======', reader.result);
      const address = (reader.result as string).split('\n')
      setAddressList(address);
      console.log(nftsIdRef.current)
      setNftsFormat(nftsIdRef.current.map((id, index) => ({
        id,
        address: address[index],
        status: 0
      })))
    };
    reader.readAsText(inputRef.current.files[0]);
  }

  const exportExcel = () => {
    downloadXlsx(Object.keys(nftsFormat[0]), nftsFormat.map( o=> Object.values(o)),  `转出表`)
  }

  return (
    <div style={{paddingTop: 30}}>
      <input type="file" ref={inputRef} />
      <button onClick={transfer}>批量转移</button>
      <button style={{marginLeft: 20}} onClick={exportExcel}>导出</button>
      <table className="nft-status">
        <thead>
          <tr>
            <th>NFT ID</th>
            <th>Transfer Address</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          {
            nftsFormat.map((nft) => (
              <tr key={nft.id}>
                <td>{nft.id}</td>
                <td>{nft.address}</td>
                <td>{nft.status}</td>
              </tr>
            ))
          }
        </tbody>
      </table>
    </div>
  )
}

export default AssetsPage;