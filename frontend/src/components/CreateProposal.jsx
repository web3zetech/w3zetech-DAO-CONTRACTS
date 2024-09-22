import React, { useState, useContext } from "react";
import { WalletContext } from "../context/WalletContext";

const CreateProposal = () => {
  const [description, setDescription] = useState("");
  const { account, web3 } = useContext(WalletContext);

  const submitProposal = async () => {
    try {
      const daoContract = new web3.eth.Contract(daoAbi, daoAddress);
      await daoContract.methods
        .createProposal(description)
        .send({ from: account });
      alert("Proposal submitted!");
    } catch (error) {
      console.error("Error creating proposal:", error);
    }
  };

  return (
    <div className="p-8">
      <h2 className="text-3xl mb-4">Create a New Proposal</h2>
      <textarea
        className="w-full p-2 border border-gray-300 rounded mb-4"
        placeholder="Enter proposal description"
        value={description}
        onChange={(e) => setDescription(e.target.value)}
      ></textarea>
      <button
        onClick={submitProposal}
        className="bg-green-500 text-white py-2 px-4 rounded hover:bg-green-600"
      >
        Submit Proposal
      </button>
    </div>
  );
};

export default CreateProposal;
