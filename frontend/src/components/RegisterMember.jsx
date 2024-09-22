import React, { useContext } from "react";
import { WalletContext } from "../context/WalletContext";

const RegisterMember = ({ setIsRegistered }) => {
  const { account, web3 } = useContext(WalletContext);

  const registerMember = async () => {
    // Call the contract function to register the user
    try {
      const daoContract = new web3.eth.Contract(daoAbi, daoAddress);
      await daoContract.methods.registerMember().send({ from: account });
      setIsRegistered(true);
    } catch (error) {
      console.error("Error registering member:", error);
    }
  };

  return (
    <button
      onClick={registerMember}
      className="bg-green-500 text-white py-2 px-4 rounded"
    >
      Register as a DAO Member
    </button>
  );
};

export default RegisterMember;
