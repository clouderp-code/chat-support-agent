import React, { useState } from 'react';
import {
  Container,
  Grid,
  Paper,
  Typography,
  TextField,
  Box,
  Button,
  Chip,
} from '@mui/material';
import { useNavigate } from 'react-router-dom';
import SearchIcon from '@mui/icons-material/Search';

interface Article {
  id: number;
  title: string;
  category: string;
  excerpt: string;
  content: string;
  author: string;
  date: string;
}

const articles: Article[] = [
  {
    id: 1,
    title: 'Understanding Service Desk Best Practices',
    category: 'Best Practices',
    excerpt: 'Learn about the essential practices for maintaining high-quality customer support through your service desk.',
    content: `Service desk best practices are essential for maintaining high-quality customer support.
      
      Key Points:
      1. Quick Response Times
      Responding to customer inquiries promptly is crucial. Aim to acknowledge tickets within 
      the first hour of submission.

      2. Clear Communication
      Use simple, clear language when communicating with customers. Avoid technical jargon 
      unless necessary, and explain complex terms when they must be used.

      3. Proper Ticket Management
      Maintain organized ticket queues and use appropriate prioritization.`,
    author: 'John Smith',
    date: '2024-02-15'
  },
  {
    id: 2,
    title: 'Troubleshooting Common IT Issues',
    category: 'Technical',
    excerpt: 'A comprehensive guide to resolving the most frequent technical issues encountered by users.',
    content: `This guide covers the most common IT issues and their solutions.
      
      Common Issues:
      1. Network Connectivity Problems
      - Check physical connections
      - Verify WiFi settings
      - Reset network adapter

      2. Software Performance Issues
      - Clear cache and temporary files
      - Update software to latest version
      - Check system requirements`,
    author: 'Sarah Johnson',
    date: '2024-02-14'
  },
  {
    id: 3,
    title: 'Password Security Guidelines',
    category: 'Security',
    excerpt: 'Essential guidelines for creating and maintaining secure passwords across your organization.',
    content: `Maintaining strong password security is crucial for organizational safety.
      
      Key Guidelines:
      1. Password Complexity
      - Minimum 12 characters
      - Mix of uppercase and lowercase
      - Include numbers and special characters

      2. Password Management
      - Use password managers
      - Regular password updates
      - No password sharing`,
    author: 'Mike Wilson',
    date: '2024-02-13'
  },
  {
    id: 4,
    title: 'Cloud Storage Best Practices',
    category: 'Cloud Computing',
    excerpt: 'Learn how to effectively manage and secure your cloud storage solutions.',
    content: `Optimize your cloud storage usage with these best practices.
      
      Important Considerations:
      1. Data Organization
      - Implement clear folder structures
      - Use consistent naming conventions
      - Regular cleanup of unused files

      2. Security Measures
      - Enable two-factor authentication
      - Regular access reviews
      - Encryption for sensitive data`,
    author: 'Emily Chen',
    date: '2024-02-12'
  },
  {
    id: 5,
    title: 'Email Management Tips',
    category: 'Productivity',
    excerpt: 'Effective strategies for managing email communications and maintaining inbox organization.',
    content: `Master your email management with these professional tips.
      
      Key Strategies:
      1. Inbox Organization
      - Use folders and labels
      - Set up email filters
      - Regular archive schedule

      2. Email Etiquette
      - Clear subject lines
      - Proper formatting
      - Response time guidelines`,
    author: 'David Brown',
    date: '2024-02-11'
  }
];

const KnowledgeBasePage: React.FC = () => {
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<string | null>(null);

  const categories = Array.from(new Set(articles.map(article => article.category)));

  const filteredArticles = articles.filter(article => {
    const matchesSearch = article.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         article.excerpt.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesCategory = !selectedCategory || article.category === selectedCategory;
    return matchesSearch && matchesCategory;
  });

  const handleReadMore = (articleId: number) => {
    navigate(`/knowledge/article/${articleId}`);
  };

  return (
    <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
      <Typography variant="h4" gutterBottom>
        Knowledge Base
      </Typography>

      {/* Search and Filter Section */}
      <Paper sx={{ p: 2, mb: 3 }}>
        <Grid container spacing={2}>
          <Grid item xs={12} md={6}>
            <TextField
              fullWidth
              variant="outlined"
              placeholder="Search articles..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              InputProps={{
                startAdornment: <SearchIcon sx={{ mr: 1, color: 'text.secondary' }} />,
              }}
            />
          </Grid>
          <Grid item xs={12} md={6}>
            <Box sx={{ display: 'flex', gap: 1, flexWrap: 'wrap' }}>
              {categories.map((category) => (
                <Chip
                  key={category}
                  label={category}
                  onClick={() => setSelectedCategory(selectedCategory === category ? null : category)}
                  color={selectedCategory === category ? 'primary' : 'default'}
                  sx={{ '&:hover': { cursor: 'pointer' } }}
                />
              ))}
            </Box>
          </Grid>
        </Grid>
      </Paper>

      {/* Articles Grid */}
      <Grid container spacing={3}>
        {filteredArticles.map((article) => (
          <Grid item xs={12} md={6} key={article.id}>
            <Paper sx={{ p: 2 }}>
              <Typography variant="h6">{article.title}</Typography>
              <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                {article.excerpt}
              </Typography>
              <Button
                variant="text"
                onClick={() => handleReadMore(article.id)}
                sx={{ textTransform: 'none' }}
              >
                Read More
              </Button>
            </Paper>
          </Grid>
        ))}
      </Grid>

      {filteredArticles.length === 0 && (
        <Paper sx={{ p: 3, textAlign: 'center' }}>
          <Typography variant="h6" color="text.secondary">
            No articles found matching your search criteria
          </Typography>
        </Paper>
      )}
    </Container>
  );
};

export default KnowledgeBasePage;
