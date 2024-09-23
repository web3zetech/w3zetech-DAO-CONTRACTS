import { ApolloClient, InMemoryCache } from "@apollo/client";


const client = new ApolloClient({
  uri: "https://api.studio.thegraph.com/query/89640/real_dao/version/latest", 
  cache: new InMemoryCache(),
});

export default client;
