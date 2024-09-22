import React, { useContext, useState, useEffect } from 'react';
import { WalletContext } from '../context/WalletContext';
import ABI from  "../../../ABI/DAO.mjs";

const daoAddress = '0x51632D52aa0b31EeF31D80DAa9DA1bCf2724D53C'; // DAO contract address

const ProposalList = () => {
  const { account, web3 } = useContext(WalletContext);
  const [proposals, setProposals] = useState([]);

  // useEffect(() => {
  //   const fetchProposals = async () => {
  //     if (web3) {
  //       const daoContract = new web3.eth.Contract(ABI, daoAddress);
  //       // Fetch proposal details here
  //       const proposalCount = await daoContract.methods.getProposalCount().call();
  //       const loadedProposals = [];
  //       for (let i = 0; i < proposalCount; i++) {
  //         const proposal = await daoContract.methods.getProposal(i).call();
  //         loadedProposals.push(proposal);
  //       }
  //       setProposals(loadedProposals);
  //     }
  //   };
  //   fetchProposals();
  // }, [web3]);

  const voteOnProposal = async (proposalId, vote) => {
    try {
      const daoContract = new web3.eth.Contract(ABI, daoAddress);
      await daoContract.methods.vote(proposalId, vote).send({ from: account });
    } catch (error) {
      console.error('Error voting on proposal:', error);
    }
  };

  return (
    <div>
      <h2>Proposals</h2>
      {proposals.length > 0 ? (
        proposals.map((proposal, index) => (
          <div key={index} className="border p-4 mb-4">
            <p>{proposal.description}</p>
            <button onClick={() => voteOnProposal(index, true)} className="mr-2">
              Vote Yes
            </button>
            <button onClick={() => voteOnProposal(index, false)}>Vote No</button>
          </div>
        ))
      ) : (
        <p>No proposals available.</p>
      )}
    </div>
  );
};

export default ProposalList;
