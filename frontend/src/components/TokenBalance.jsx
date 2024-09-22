import React, { useContext, useEffect, useState } from "react";
import { WalletContext } from "../context/WalletContext";
import Web3 from "web3";

const tokenAbi = []; // Token contract ABI goes here
const tokenAddress = "0xD818e3AD00F322ebb2A3659A09c1d44C5C447011"; // Token contract address

const TokenBalance = () => {
  const { account, web3 } = useContext(WalletContext);
  const [balance, setBalance] = useState(0);

  useEffect(() => {
    const fetchBalance = async () => {
      if (account && web3) {
        const tokenContract = new web3.eth.Contract(tokenAbi, tokenAddress);
        const balance = await tokenContract.methods.balanceOf(account).call();
        const decimals = await tokenContract.methods.decimals().call();
        setBalance(Web3.utils.fromWei(balance, `ether${decimals}`));
      }
    };
    fetchBalance();
  }, [account, web3]);

  return (
    <div className="mt-4">
      {account ? (
        <h2>Your Token Balance: {balance} W3Z</h2>
      ) : (
        <p>Please connect your wallet to see your balance.</p>
      )}
    </div>
  );
};

export default TokenBalance;
