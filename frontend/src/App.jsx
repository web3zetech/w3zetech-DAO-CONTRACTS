import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import LandingPage from "./components/LandingPage";
import DashboardLayout from "./components/DashboardLayout";
import CreateProposal from "./components/CreateProposal";
import ProposalList from "./components/ProposalList";
import ProposalAnalytics from "./components/ProposalAnalytics";
import { WalletProvider } from "./context/WalletContext";

const App = () => {
  return (
    <WalletProvider>
      <Router>
        <Routes>
          <Route path="/" element={<LandingPage />} />
          <Route path="/dashboard" element={<DashboardLayout />}>
            <Route path="create-proposal" element={<CreateProposal />} />
            <Route path="vote" element={<ProposalList />} />
            <Route path="analytics" element={<ProposalAnalytics />} />
          </Route>
        </Routes>
      </Router>
    </WalletProvider>
  );
};

export default App;
