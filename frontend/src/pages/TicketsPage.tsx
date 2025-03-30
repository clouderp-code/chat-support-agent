import React from 'react';
import {
  Container,
  Paper,
  Typography,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Button,
  Box,
  Chip,
} from '@mui/material';
import AddIcon from '@mui/icons-material/Add';

const tickets = [
  {
    id: 1,
    title: 'Login Issue',
    status: 'Open',
    priority: 'High',
    created: '2023-11-20',
    updated: '2023-11-21',
  },
  {
    id: 2,
    title: 'Password Reset',
    status: 'In Progress',
    priority: 'Medium',
    created: '2023-11-19',
    updated: '2023-11-21',
  },
  {
    id: 3,
    title: 'Feature Request',
    status: 'Closed',
    priority: 'Low',
    created: '2023-11-18',
    updated: '2023-11-20',
  },
];

const TicketsPage = () => {
  return (
    <Container maxWidth="lg" sx={{ mt: 4 }}>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 3 }}>
        <Typography variant="h4">Support Tickets</Typography>
        <Button variant="contained" startIcon={<AddIcon />}>
          New Ticket
        </Button>
      </Box>

      <TableContainer component={Paper}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>ID</TableCell>
              <TableCell>Title</TableCell>
              <TableCell>Status</TableCell>
              <TableCell>Priority</TableCell>
              <TableCell>Created</TableCell>
              <TableCell>Updated</TableCell>
              <TableCell>Actions</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {tickets.map((ticket) => (
              <TableRow key={ticket.id}>
                <TableCell>{ticket.id}</TableCell>
                <TableCell>{ticket.title}</TableCell>
                <TableCell>
                  <Chip
                    label={ticket.status}
                    color={
                      ticket.status === 'Open'
                        ? 'error'
                        : ticket.status === 'In Progress'
                        ? 'warning'
                        : 'success'
                    }
                    size="small"
                  />
                </TableCell>
                <TableCell>
                  <Chip
                    label={ticket.priority}
                    color={
                      ticket.priority === 'High'
                        ? 'error'
                        : ticket.priority === 'Medium'
                        ? 'warning'
                        : 'info'
                    }
                    size="small"
                  />
                </TableCell>
                <TableCell>{ticket.created}</TableCell>
                <TableCell>{ticket.updated}</TableCell>
                <TableCell>
                  <Button size="small" color="primary">
                    View
                  </Button>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    </Container>
  );
};

export default TicketsPage;
