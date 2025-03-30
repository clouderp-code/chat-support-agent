import React, { useState } from 'react';
import {
  Container,
  Paper,
  Typography,
  TextField,
  Button,
  Box,
  List,
  ListItem,
  ListItemText,
} from '@mui/material';
import SendIcon from '@mui/icons-material/Send';

interface Message {
  id: number;
  text: string;
  sender: 'user' | 'ai';
  timestamp: Date;
}

const ChatPage = () => {
  const [messages, setMessages] = useState<Message[]>([
    {
      id: 1,
      text: "Hello! How can I help you today?",
      sender: 'ai',
      timestamp: new Date()
    }
  ]);
  const [input, setInput] = useState('');

  const handleSend = () => {
    if (!input.trim()) return;

    const newMessage: Message = {
      id: messages.length + 1,
      text: input,
      sender: 'user',
      timestamp: new Date()
    };

    setMessages([...messages, newMessage]);
    setInput('');

    // Simulate AI response
    setTimeout(() => {
      const aiResponse: Message = {
        id: messages.length + 2,
        text: "I'm processing your request. How can I assist you further?",
        sender: 'ai',
        timestamp: new Date()
      };
      setMessages(prev => [...prev, aiResponse]);
    }, 1000);
  };

  return (
    <Container maxWidth="md" sx={{ mt: 4 }}>
      <Paper elevation={3} sx={{ height: '70vh', display: 'flex', flexDirection: 'column' }}>
        <Box sx={{ p: 2, backgroundColor: 'primary.main', color: 'white' }}>
          <Typography variant="h6">AI Chat Support</Typography>
        </Box>
        
        <Box sx={{ flexGrow: 1, overflow: 'auto', p: 2 }}>
          <List>
            {messages.map((message) => (
              <ListItem
                key={message.id}
                sx={{
                  justifyContent: message.sender === 'user' ? 'flex-end' : 'flex-start',
                  mb: 1
                }}
              >
                <Paper
                  elevation={1}
                  sx={{
                    p: 2,
                    backgroundColor: message.sender === 'user' ? 'primary.light' : 'grey.100',
                    maxWidth: '70%'
                  }}
                >
                  <ListItemText
                    primary={message.text}
                    secondary={message.timestamp.toLocaleTimeString()}
                  />
                </Paper>
              </ListItem>
            ))}
          </List>
        </Box>

        <Box sx={{ p: 2, backgroundColor: 'background.paper' }}>
          <TextField
            fullWidth
            variant="outlined"
            placeholder="Type your message..."
            value={input}
            onChange={(e) => setInput(e.target.value)}
            onKeyPress={(e) => e.key === 'Enter' && handleSend()}
            InputProps={{
              endAdornment: (
                <Button
                  variant="contained"
                  endIcon={<SendIcon />}
                  onClick={handleSend}
                  sx={{ ml: 1 }}
                >
                  Send
                </Button>
              ),
            }}
          />
        </Box>
      </Paper>
    </Container>
  );
};

export default ChatPage;
