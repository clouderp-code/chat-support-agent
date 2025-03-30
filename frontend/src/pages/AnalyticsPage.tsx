import React, { useState, useEffect } from 'react';
import {
  Container,
  Grid,
  Paper,
  Typography,
  Box,
  CircularProgress,
} from '@mui/material';

// Define interfaces at the top of the file
interface CategoryData {
  name: string;
  value: number;
}

interface AnalyticsData {
  totalTickets: number;
  resolutionRate: number;
  responseTime: number;
  activeUsers: number;
  ticketTrends: number[];
  categoryDistribution: CategoryData[];
}

// Initial state with proper typing
const initialAnalyticsData: AnalyticsData = {
  totalTickets: 0,
  resolutionRate: 0,
  responseTime: 0,
  activeUsers: 0,
  ticketTrends: [],
  categoryDistribution: [],
};

const AnalyticsPage: React.FC = () => {
  const [loading, setLoading] = useState(true);
  const [analyticsData, setAnalyticsData] = useState<AnalyticsData>(initialAnalyticsData);

  useEffect(() => {
    const fetchAnalytics = () => {
      try {
        // Now TypeScript will recognize AnalyticsData
        const data: AnalyticsData = {
          totalTickets: Math.floor(Math.random() * 2000) + 1000,
          resolutionRate: Math.floor(Math.random() * 15) + 85,
          responseTime: Number((Math.random() * 3 + 1).toFixed(1)),
          activeUsers: Math.floor(Math.random() * 200) + 100,
          ticketTrends: Array.from({ length: 7 }, () => Math.floor(Math.random() * 100)),
          categoryDistribution: [
            { name: 'Technical', value: Math.floor(Math.random() * 40) + 20 },
            { name: 'Billing', value: Math.floor(Math.random() * 30) + 15 },
            { name: 'Account', value: Math.floor(Math.random() * 20) + 10 },
            { name: 'General', value: Math.floor(Math.random() * 15) + 5 },
          ],
        };

        setAnalyticsData(data);
      } catch (error) {
        console.error('Error generating analytics:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchAnalytics();
    const interval = setInterval(fetchAnalytics, 300000); // 5 minutes
    return () => clearInterval(interval);
  }, []);

  if (loading) {
    return (
      <Container sx={{ display: 'flex', justifyContent: 'center', mt: 4 }}>
        <CircularProgress />
      </Container>
    );
  }

  return (
    <Container maxWidth="lg" sx={{ mt: 4 }}>
      <Typography variant="h4" gutterBottom>
        Analytics Dashboard
      </Typography>

      <Grid container spacing={3}>
        {/* Summary Cards */}
        <Grid item xs={12} md={3}>
          <Paper sx={{ p: 2, textAlign: 'center' }}>
            <Typography variant="h6" gutterBottom>
              Total Tickets
            </Typography>
            <Typography variant="h3" color="primary">
              {analyticsData.totalTickets.toLocaleString()}
            </Typography>
          </Paper>
        </Grid>
        <Grid item xs={12} md={3}>
          <Paper sx={{ p: 2, textAlign: 'center' }}>
            <Typography variant="h6" gutterBottom>
              Resolution Rate
            </Typography>
            <Typography variant="h3" color="success.main">
              {analyticsData.resolutionRate}%
            </Typography>
          </Paper>
        </Grid>
        <Grid item xs={12} md={3}>
          <Paper sx={{ p: 2, textAlign: 'center' }}>
            <Typography variant="h6" gutterBottom>
              Avg Response Time
            </Typography>
            <Typography variant="h3" color="info.main">
              {analyticsData.responseTime}h
            </Typography>
          </Paper>
        </Grid>
        <Grid item xs={12} md={3}>
          <Paper sx={{ p: 2, textAlign: 'center' }}>
            <Typography variant="h6" gutterBottom>
              Active Users
            </Typography>
            <Typography variant="h3" color="secondary.main">
              {analyticsData.activeUsers}
            </Typography>
          </Paper>
        </Grid>

        {/* Charts Section */}
        <Grid item xs={12} md={8}>
          <Paper sx={{ p: 2 }}>
            <Typography variant="h6" gutterBottom>
              Ticket Trends (Last 7 Days)
            </Typography>
            <Box sx={{ height: 300, bgcolor: 'grey.100', p: 2 }}>
              {analyticsData.ticketTrends.map((value, index) => (
                <Box
                  key={index}
                  sx={{
                    display: 'inline-block',
                    width: '12%',
                    mx: '1%',
                    height: `${value}%`,
                    bgcolor: 'primary.main',
                    position: 'relative',
                    bottom: 0,
                    transition: 'height 0.3s ease',
                  }}
                />
              ))}
            </Box>
          </Paper>
        </Grid>

        <Grid item xs={12} md={4}>
          <Paper sx={{ p: 2 }}>
            <Typography variant="h6" gutterBottom>
              Category Distribution
            </Typography>
            <Box sx={{ height: 300, bgcolor: 'grey.100', p: 2 }}>
              {analyticsData.categoryDistribution.map((category, index) => (
                <Box key={index} sx={{ mb: 2 }}>
                  <Typography variant="body2">
                    {category.name}: {category.value}%
                  </Typography>
                  <Box
                    sx={{
                      width: `${category.value}%`,
                      height: 20,
                      bgcolor: `${['primary', 'secondary', 'success', 'info'][index]}.main`,
                      borderRadius: 1,
                    }}
                  />
                </Box>
              ))}
            </Box>
          </Paper>
        </Grid>
      </Grid>
    </Container>
  );
};

export default AnalyticsPage;
