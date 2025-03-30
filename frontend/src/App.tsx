import React from 'react';
import { BrowserRouter as Router, Routes, Route, useNavigate } from 'react-router-dom';
import { ThemeProvider, createTheme } from '@mui/material/styles';
import CssBaseline from '@mui/material/CssBaseline';
import {
  AppBar,
  Toolbar,
  Typography,
  Button,
  Box,
} from '@mui/material';

import HomePage from './pages/HomePage';
import ChatPage from './pages/ChatPage';
import TicketsPage from './pages/TicketsPage';
import KnowledgeBasePage from './pages/KnowledgeBasePage';
import AnalyticsPage from './pages/AnalyticsPage';
import ArticleDetailPage from './pages/ArticleDetailPage';

const theme = createTheme({
  palette: {
    mode: 'light',
    primary: {
      main: '#1976d2',
    },
    secondary: {
      main: '#dc004e',
    },
  },
});

function Navigation() {
  const navigate = useNavigate();

  return (
    <AppBar position="static">
      <Toolbar>
        <Typography 
          variant="h6" 
          component="div" 
          sx={{ flexGrow: 1, cursor: 'pointer' }}
          onClick={() => navigate('/')}
        >
          AI Service Desk
        </Typography>
        <Button color="inherit" onClick={() => navigate('/chat')}>Chat</Button>
        <Button color="inherit" onClick={() => navigate('/tickets')}>Tickets</Button>
        <Button color="inherit" onClick={() => navigate('/knowledge')}>Knowledge Base</Button>
        <Button color="inherit" onClick={() => navigate('/analytics')}>Analytics</Button>
      </Toolbar>
    </AppBar>
  );
}

function App() {
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <Router>
        <Box sx={{ flexGrow: 1 }}>
          <Navigation />
          <Routes>
            <Route path="/" element={<HomePage />} />
            <Route path="/chat" element={<ChatPage />} />
            <Route path="/tickets" element={<TicketsPage />} />
            <Route path="/knowledge" element={<KnowledgeBasePage />} />
            <Route path="/knowledge/article/:id" element={<ArticleDetailPage />} />
            <Route path="/analytics" element={<AnalyticsPage />} />
          </Routes>
        </Box>
      </Router>
    </ThemeProvider>
  );
}

export default App;
