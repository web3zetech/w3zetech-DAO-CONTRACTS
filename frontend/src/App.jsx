import React from 'react';
import { WalletProvider } from './context/WalletContext';
import ConnectWallet from './components/ConnectWallet';
import Dashboard from './components/Dashboard';
import { ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

const App = () => {
  return (
    <WalletProvider>
      <div className="App">
        <ToastContainer />
        <ConnectWallet />
        <Dashboard />
      </div>
    </WalletProvider>
  );
};

export default App;
