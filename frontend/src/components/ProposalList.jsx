import React, { useEffect, useState, useContext } from "react";
import { WalletContext } from "../context/WalletContext";
import ProposalCard from "./ProposalCard";

const ProposalList = () => {
  const { account, web3 } = useContext(WalletContext);
  const [proposals, setProposals] = useState([]);

  useEffect(() => {
    const fetchProposals = async () => {
      const daoContract = new web3.eth.Contract(daoAbi, daoAddress);
      const proposalCount = await daoContract.methods.proposalCount().call();
      let proposalList = [];
      for (let i = 0; i < proposalCount; i++) {
        const proposal = await daoContract.methods.getProposal(i).call();
        proposalList.push(proposal);
      }
      setProposals(proposalList);
    };
    fetchProposals();
  }, [account, web3]);

  return (
    <div className="p-8">
      <h2 className="text-3xl mb-4">Active Proposals</h2>
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        {proposals.map((proposal, index) => (
          <ProposalCard key={index} proposal={proposal} />
        ))}
      </div>
    </div>
  );
};

export default ProposalList;
