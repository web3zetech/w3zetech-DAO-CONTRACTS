import React, { useContext, useState } from "react";
import { WalletContext } from "../context/WalletContext";
import RegisterMember from "./RegisterMember";

const LandingPage = () => {
  const { account, connectWallet } = useContext(WalletContext);
  const [isRegistered, setIsRegistered] = useState(false); // Track if the user has registered

  return (
    <div className="h-screen flex flex-col items-center justify-center bg-gray-100">
      <h1 className="text-4xl font-bold mb-4">Welcome to School DAO</h1>
      {!account ? (
        <button
          onClick={connectWallet}
          className="bg-blue-600 text-white py-2 px-4 rounded hover:bg-blue-700"
        >
          Connect MetaMask
        </button>
      ) : (
        <p className="text-green-600">
          You are registered as a member. Go to the{" "}
          <a href="/dashboard">Dashboard</a>
        </p>
      )}
    </div>
  );
};

export default LandingPage;
