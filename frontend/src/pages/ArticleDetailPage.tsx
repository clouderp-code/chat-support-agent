import React from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import {
  Container,
  Paper,
  Typography,
  Box,
  Breadcrumbs,
  Link,
  Button,
} from '@mui/material';
import ArrowBackIcon from '@mui/icons-material/ArrowBack';

interface Article {
  id: number;
  title: string;
  category: string;
  content: string;
  author: string;
  date: string;
}

const ArticleDetailPage: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();

  // Mock article data - in a real app, this would come from an API
  const article: Article = {
    id: Number(id),
    title: 'Understanding Service Desk Best Practices',
    category: 'Best Practices',
    content: `
      Service desk best practices are essential for maintaining high-quality customer support.
      
      Key Points:
      1. Quick Response Times
      Responding to customer inquiries promptly is crucial. Aim to acknowledge tickets within 
      the first hour of submission.

      2. Clear Communication
      Use simple, clear language when communicating with customers. Avoid technical jargon 
      unless necessary, and explain complex terms when they must be used.

      3. Proper Ticket Management
      Maintain organized ticket queues and use appropriate prioritization. Critical issues 
      should be escalated immediately, while routine requests can be handled in order of receipt.

      4. Knowledge Base Maintenance
      Regularly update the knowledge base with new solutions and common issues. This helps 
      both customers and service desk agents find answers quickly.

      5. Continuous Improvement
      Regular review of service desk metrics and customer feedback helps identify areas for 
      improvement and optimization.
    `,
    author: 'John Smith',
    date: '2024-02-15',
  };

  const handleBack = () => {
    navigate('/knowledge');
  };

  return (
    <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
      <Box sx={{ mb: 4 }}>
        <Button
          startIcon={<ArrowBackIcon />}
          onClick={handleBack}
          sx={{ mb: 2 }}
        >
          Back to Knowledge Base
        </Button>
        <Breadcrumbs aria-label="breadcrumb">
          <Link color="inherit" href="/" onClick={(e) => {
            e.preventDefault();
            navigate('/');
          }}>
            Home
          </Link>
          <Link color="inherit" href="/knowledge" onClick={(e) => {
            e.preventDefault();
            navigate('/knowledge');
          }}>
            Knowledge Base
          </Link>
          <Typography color="text.primary">{article.title}</Typography>
        </Breadcrumbs>
      </Box>

      <Paper sx={{ p: 4 }}>
        <Typography variant="h4" gutterBottom>
          {article.title}
        </Typography>
        <Box sx={{ mb: 3 }}>
          <Typography variant="subtitle1" color="text.secondary">
            Category: {article.category}
          </Typography>
          <Typography variant="subtitle2" color="text.secondary">
            By {article.author} | {article.date}
          </Typography>
        </Box>
        <Typography variant="body1" sx={{ whiteSpace: 'pre-wrap' }}>
          {article.content}
        </Typography>
      </Paper>
    </Container>
  );
};

export default ArticleDetailPage;
