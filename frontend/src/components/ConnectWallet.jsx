import React, { useContext } from 'react';
import { WalletContext } from '../context/WalletContext';

const ConnectWallet = () => {
  const { account, connectWallet } = useContext(WalletContext);

  return (
    <div className="flex justify-center items-center mt-10">
      {account ? (
        <p className="text-green-600">Wallet Connected: {account}</p>
      ) : (
        <button
          onClick={connectWallet}
          className="bg-blue-500 text-white py-2 px-4 rounded"
        >
          Connect MetaMask
        </button>
      )}
    </div>
  );
};

export default ConnectWallet;
