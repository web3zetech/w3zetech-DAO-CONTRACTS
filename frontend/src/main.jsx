import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import App from './App.jsx'
import './index.css'
import {ApolloProvider} from "@apollo/client";
import client  from './ApolloClient';

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <App />
    <ApolloProvider/>
  </StrictMode>,
)
