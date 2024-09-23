import { useQuery, QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { gql, request } from 'graphql-request'
import React from 'react';
import ReactDOM from 'react-dom/client';
const query = gql`{
  proposalCreateds(first: 5) {
    id
    proposalId
    proposer
    description
  }
  proposalExecuteds(first: 5) {
    id
    proposalId
    passed
    blockNumber
  }
}`
const url = 'https://api.studio.thegraph.com/query/89640/real_dao/version/latest'
export default function App() {
  const { data, status } = useQuery({
    queryKey: ['data'],
    async queryFn() {
      return await request(url, query)
    }
  })
  return (
    <main>
      {status === 'pending' ? <div>Loading...</div> : null}
      {status === 'error' ? <div>Error ocurred querying the Subgraph</div> : null}
      <div>{JSON.stringify(data ?? {})}</div>
    </main>
  )
}
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 60 * 1000,
    },
  },
});
ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <QueryClientProvider client={queryClient}>
      <App />
    </QueryClientProvider>
  </React.StrictMode>,
);
      