import React from 'react';
import {
  Container,
  Grid,
  Paper,
  Typography,
  Box,
} from '@mui/material';

const AnalyticsPage = () => {
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
              1,234
            </Typography>
          </Paper>
        </Grid>
        <Grid item xs={12} md={3}>
          <Paper sx={{ p: 2, textAlign: 'center' }}>
            <Typography variant="h6" gutterBottom>
              Resolution Rate
            </Typography>
            <Typography variant="h3" color="success.main">
              94%
            </Typography>
          </Paper>
        </Grid>
        <Grid item xs={12} md={3}>
          <Paper sx={{ p: 2, textAlign: 'center' }}>
            <Typography variant="h6" gutterBottom>
              Avg Response Time
            </Typography>
            <Typography variant="h3" color="info.main">
              2.5h
            </Typography>
          </Paper>
        </Grid>
        <Grid item xs={12} md={3}>
          <Paper sx={{ p: 2, textAlign: 'center' }}>
            <Typography variant="h6" gutterBottom>
              Active Users
            </Typography>
            <Typography variant="h3" color="secondary.main">
              156
            </Typography>
          </Paper>
        </Grid>

        {/* Charts Section */}
        <Grid item xs={12} md={8}>
          <Paper sx={{ p: 2 }}>
            <Typography variant="h6" gutterBottom>
              Ticket Trends
            </Typography>
            <Box sx={{ height: 300, bgcolor: 'grey.100' }}>
              {/* Add chart component here */}
              <Typography variant="body2" sx={{ p: 2, textAlign: 'center' }}>
                Chart placeholder: Ticket volume over time
              </Typography>
            </Box>
          </Paper>
        </Grid>

        <Grid item xs={12} md={4}>
          <Paper sx={{ p: 2 }}>
            <Typography variant="h6" gutterBottom>
              Category Distribution
            </Typography>
            <Box sx={{ height: 300, bgcolor: 'grey.100' }}>
              {/* Add pie chart component here */}
              <Typography variant="body2" sx={{ p: 2, textAlign: 'center' }}>
                Chart placeholder: Ticket categories
              </Typography>
            </Box>
          </Paper>
        </Grid>
      </Grid>
    </Container>
  );
};

export default AnalyticsPage;
