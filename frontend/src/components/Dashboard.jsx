import React from 'react';
import TokenBalance from './TokenBalance';
import ProposalList from './ProposalList';

const Dashboard = () => {
  return (
    <div className="container mx-auto p-5">
      <h1 className="text-3xl font-bold mb-4">DAO Dashboard</h1>
      <TokenBalance />
      <ProposalList />
    </div>
  );
};

export default Dashboard;
