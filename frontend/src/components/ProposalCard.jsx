import React, { useContext } from "react";
import { WalletContext } from "../context/WalletContext";

const ProposalCard = ({ proposal }) => {
  const { account, web3 } = useContext(WalletContext);

  const voteOnProposal = async (vote) => {
    try {
      const daoContract = new web3.eth.Contract(daoAbi, daoAddress);
      await daoContract.methods.vote(proposal.id, vote).send({ from: account });
      alert("Vote submitted!");
    } catch (error) {
      console.error("Error voting on proposal:", error);
    }
  };

  return (
    <div className="p-4 border rounded shadow bg-white">
      <h3 className="text-xl font-bold mb-2">
        Proposal: {proposal.description}
      </h3>
      <button
        onClick={() => voteOnProposal(true)}
        className="bg-green-500 text-white py-1 px-4 rounded hover:bg-green-600 mr-2"
      >
        Vote Yes
      </button>
      <button
        onClick={() => voteOnProposal(false)}
        className="bg-red-500 text-white py-1 px-4 rounded hover:bg-red-600"
      >
        Vote No
      </button>
    </div>
  );
};

export default ProposalCard;
