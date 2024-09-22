import React, { useEffect, useState } from "react";

const ProposalAnalytics = () => {
  const [analyticsData, setAnalyticsData] = useState([]);

  useEffect(() => {
    // Fetch analytics data from The Graph
    const fetchAnalyticsData = async () => {
      const response = await fetch(
        "https://api.thegraph.com/subgraphs/name/your-subgraph",
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            query: `
            {
              proposals {
                id
                description
                votes {
                  voter
                  choice
                }
              }
            }
          `,
          }),
        }
      );
      const data = await response.json();
      setAnalyticsData(data.data.proposals);
    };

    fetchAnalyticsData();
  }, []);

  return (
    <div className="p-8">
      <h2 className="text-3xl mb-4">Proposal Analytics</h2>
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        {analyticsData.map((proposal, index) => (
          <div key={index} className="p-4 border rounded shadow bg-white">
            <h3 className="text-xl font-bold mb-2">{proposal.description}</h3>
            <p>Total Votes: {proposal.votes.length}</p>
          </div>
        ))}
      </div>
    </div>
  );
};

export default ProposalAnalytics;
