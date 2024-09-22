import React from "react";
import { NavLink } from "react-router-dom";

const Sidebar = () => {
  return (
    <div className="w-64 bg-blue-800 text-white h-screen flex flex-col">
      <h2 className="text-2xl font-bold p-4">DAO Dashboard</h2>
      <NavLink
        to="/dashboard/create-proposal"
        className="p-4 hover:bg-blue-700"
        activeClassName="bg-blue-600"
      >
        Create Proposal
      </NavLink>
      <NavLink
        to="/dashboard/vote"
        className="p-4 hover:bg-blue-700"
        activeClassName="bg-blue-600"
      >
        Voting
      </NavLink>
      <NavLink
        to="/dashboard/analytics"
        className="p-4 hover:bg-blue-700"
        activeClassName="bg-blue-600"
      >
        Proposal Analytics
      </NavLink>
    </div>
  );
};

export default Sidebar;
