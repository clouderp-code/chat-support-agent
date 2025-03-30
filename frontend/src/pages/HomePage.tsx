import React from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Container,
  Grid,
  Paper,
  Typography,
  Box,
  Button,
} from '@mui/material';
import {
  Chat as ChatIcon,
  Assignment as TicketIcon,
  Book as KnowledgeIcon,
  Analytics as AnalyticsIcon,
} from '@mui/icons-material';

const HomePage = () => {
  const navigate = useNavigate();

  return (
    <Container maxWidth="lg" sx={{ mt: 4 }}>
      <Grid container spacing={3}>
        {/* Welcome Section */}
        <Grid item xs={12}>
          <Paper sx={{ p: 3, textAlign: 'center' }}>
            <Typography variant="h4" gutterBottom>
              Welcome to AI Service Desk
            </Typography>
            <Typography variant="subtitle1" color="text.secondary">
              Your 24/7 Intelligent Support Assistant
            </Typography>
          </Paper>
        </Grid>

        {/* Quick Actions */}
        <Grid item xs={12} md={3}>
          <Paper 
            sx={{ 
              p: 2, 
              textAlign: 'center', 
              height: '100%',
              cursor: 'pointer',
              '&:hover': { bgcolor: 'action.hover' }
            }}
            onClick={() => navigate('/chat')}
          >
            <ChatIcon sx={{ fontSize: 40, color: 'primary.main', mb: 1 }} />
            <Typography variant="h6">Start Chat</Typography>
            <Typography variant="body2" color="text.secondary">
              Get instant support
            </Typography>
          </Paper>
        </Grid>

        <Grid item xs={12} md={3}>
          <Paper 
            sx={{ 
              p: 2, 
              textAlign: 'center', 
              height: '100%',
              cursor: 'pointer',
              '&:hover': { bgcolor: 'action.hover' }
            }}
            onClick={() => navigate('/tickets')}
          >
            <TicketIcon sx={{ fontSize: 40, color: 'secondary.main', mb: 1 }} />
            <Typography variant="h6">Submit Ticket</Typography>
            <Typography variant="body2" color="text.secondary">
              Create support ticket
            </Typography>
          </Paper>
        </Grid>

        <Grid item xs={12} md={3}>
          <Paper 
            sx={{ 
              p: 2, 
              textAlign: 'center', 
              height: '100%',
              cursor: 'pointer',
              '&:hover': { bgcolor: 'action.hover' }
            }}
            onClick={() => navigate('/knowledge')}
          >
            <KnowledgeIcon sx={{ fontSize: 40, color: 'success.main', mb: 1 }} />
            <Typography variant="h6">Knowledge Base</Typography>
            <Typography variant="body2" color="text.secondary">
              Browse articles
            </Typography>
          </Paper>
        </Grid>

        <Grid item xs={12} md={3}>
          <Paper 
            sx={{ 
              p: 2, 
              textAlign: 'center', 
              height: '100%',
              cursor: 'pointer',
              '&:hover': { bgcolor: 'action.hover' }
            }}
            onClick={() => navigate('/analytics')}
          >
            <AnalyticsIcon sx={{ fontSize: 40, color: 'info.main', mb: 1 }} />
            <Typography variant="h6">Analytics</Typography>
            <Typography variant="body2" color="text.secondary">
              View insights
            </Typography>
          </Paper>
        </Grid>

        {/* Stats Section */}
        <Grid item xs={12}>
          <Paper sx={{ p: 3 }}>
            <Typography variant="h5" gutterBottom>
              System Status
            </Typography>
            <Grid container spacing={2}>
              <Grid item xs={3}>
                <Typography variant="h6">Active Chats</Typography>
                <Typography variant="h4" color="primary">12</Typography>
              </Grid>
              <Grid item xs={3}>
                <Typography variant="h6">Open Tickets</Typography>
                <Typography variant="h4" color="secondary">25</Typography>
              </Grid>
              <Grid item xs={3}>
                <Typography variant="h6">KB Articles</Typography>
                <Typography variant="h4" color="success.main">156</Typography>
              </Grid>
              <Grid item xs={3}>
                <Typography variant="h6">Response Rate</Typography>
                <Typography variant="h4" color="info.main">98%</Typography>
              </Grid>
            </Grid>
          </Paper>
        </Grid>
      </Grid>
    </Container>
  );
};

export default HomePage;
