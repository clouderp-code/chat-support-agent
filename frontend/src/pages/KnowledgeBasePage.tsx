import React from 'react';
import {
  Container,
  Grid,
  Paper,
  Typography,
  TextField,
  Card,
  CardContent,
  CardActions,
  Button,
  Box,
} from '@mui/material';
import SearchIcon from '@mui/icons-material/Search';

const articles = [
  {
    id: 1,
    title: 'Getting Started Guide',
    category: 'General',
    excerpt: 'Learn how to get started with our platform...',
  },
  {
    id: 2,
    title: 'Password Reset Process',
    category: 'Security',
    excerpt: 'Step-by-step guide to reset your password...',
  },
  {
    id: 3,
    title: 'Common Issues & Solutions',
    category: 'Troubleshooting',
    excerpt: 'Find solutions to common problems...',
  },
  {
    id: 4,
    title: 'API Documentation',
    category: 'Development',
    excerpt: 'Complete API reference and examples...',
  },
];

const KnowledgeBasePage = () => {
  return (
    <Container maxWidth="lg" sx={{ mt: 4 }}>
      <Typography variant="h4" gutterBottom>
        Knowledge Base
      </Typography>

      <Box sx={{ mb: 4 }}>
        <TextField
          fullWidth
          variant="outlined"
          placeholder="Search articles..."
          InputProps={{
            startAdornment: <SearchIcon sx={{ mr: 1, color: 'text.secondary' }} />,
          }}
        />
      </Box>

      <Grid container spacing={3}>
        {articles.map((article) => (
          <Grid item xs={12} md={6} key={article.id}>
            <Card>
              <CardContent>
                <Typography variant="h6" gutterBottom>
                  {article.title}
                </Typography>
                <Typography variant="subtitle2" color="text.secondary" gutterBottom>
                  Category: {article.category}
                </Typography>
                <Typography variant="body2" color="text.secondary">
                  {article.excerpt}
                </Typography>
              </CardContent>
              <CardActions>
                <Button size="small" color="primary">
                  Read More
                </Button>
              </CardActions>
            </Card>
          </Grid>
        ))}
      </Grid>
    </Container>
  );
};

export default KnowledgeBasePage;
