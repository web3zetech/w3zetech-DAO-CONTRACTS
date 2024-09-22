import React, { createContext, useState, useEffect } from 'react';
import { Web3 } from "web3";
import { toast } from 'react-toastify';

export const WalletContext = createContext();

export const WalletProvider = ({ children }) => {
  const [account, setAccount] = useState(null);
  const [web3, setWeb3] = useState(null);

  const connectWallet = async () => {
    try {
      console.log("connecting..")
      if (typeof window.ethereum !== 'undefined') {
        const web3Instance = new Web3(window.ethereum);
        setWeb3(web3Instance);

        // Request wallet connection
        const accounts = await web3Instance.eth.requestAccounts();
        setAccount(accounts[0]);
        toast.success('Wallet connected successfully!');
      } else {
        throw new Error('MetaMask is not installed.');
      }
    } catch (error) {
      console.error('Error connecting to MetaMask:', error);
      toast.error(error.message || 'Error connecting to wallet');
    }
  };

  useEffect(() => {
    const checkWalletConnection = async () => {
      try {
        if (typeof window.ethereum !== 'undefined') {
          const web3Instance = new Web3(window.ethereum);
          setWeb3(web3Instance);

          // Check if wallet is already connected
          const accounts = await window.ethereum.request({ method: 'eth_accounts' });
          if (accounts.length > 0) {
            setAccount(accounts[0]);
          } else {
            toast.info('Please connect to MetaMask.');
          }
        } else {
          toast.error('MetaMask not detected. Please install MetaMask.');
        }
      } catch (error) {
        console.error('Error checking wallet connection:', error);
      }
    };

    checkWalletConnection();
  }, []);

  return (
    <WalletContext.Provider value={{ account, connectWallet, web3 }}>
      {children}
    </WalletContext.Provider>
  );
};

