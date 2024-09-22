import React from "react";
import Sidebar from "./Sidebar";
import { Outlet } from "react-router-dom"; // Used to render different pages in the dashboard

const DashboardLayout = () => {
  return (
    <div className="flex h-screen">
      <Sidebar />
      <div className="flex-grow bg-gray-100 p-8">
        <Outlet />{" "}
        {/* This will render the selected component from the sidebar */}
      </div>
    </div>
  );
};

export default DashboardLayout;
