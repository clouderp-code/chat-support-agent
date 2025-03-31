import React, { useState, useRef, useEffect } from 'react';
import {
  Box,
  TextField,
  Button,
  Paper,
  Typography,
  CircularProgress,
} from '@mui/material';
import SendIcon from '@mui/icons-material/Send';

interface Message {
  id: string;
  content: string;
  sender: 'user' | 'ai';
  timestamp: Date;
}

const ChatWindow: React.FC = () => {
  const [messages, setMessages] = useState<Message[]>([]);
  const [input, setInput] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const messagesEndRef = useRef<null | HTMLDivElement>(null);
  const [ws, setWs] = useState<WebSocket | null>(null);

  useEffect(() => {
    console.log('Initializing new WebSocket connection...');
    const websocket = new WebSocket('ws://localhost:8000/api/chat/ws');

    websocket.onopen = () => {
      console.log('WebSocket connection established');
      // Send a test message to verify connection
      try {
        websocket.send(JSON.stringify({
          message: "Test connection",
          timestamp: new Date().toISOString()
        }));
        console.log('Test message sent successfully');
      } catch (error) {
        console.error('Error sending test message:', error);
      }
    };

    websocket.onmessage = (event) => {
      console.log('Raw WebSocket message received:', event.data);
      try {
        const response = JSON.parse(event.data);
        console.log('Parsed WebSocket response:', response);

        if (response && response.response) {
          console.log('Creating new AI message with response:', response.response);
          const newMessage: Message = {
            id: Date.now().toString(),
            content: response.response,
            sender: 'ai',
            timestamp: new Date()
          };
          setMessages(prev => {
            console.log('Previous messages:', prev);
            console.log('Adding new message:', newMessage);
            return [...prev, newMessage];
          });
        } else {
          console.warn('Received response without response field:', response);
        }
      } catch (error) {
        console.error('Error processing WebSocket message:', error);
      }
      setIsLoading(false);
    };

    websocket.onerror = (error) => {
      console.error('WebSocket error occurred:', error);
      setIsLoading(false);
    };

    websocket.onclose = (event) => {
      console.log('WebSocket connection closed:', event);
    };

    setWs(websocket);

    return () => {
      console.log('Cleaning up WebSocket connection');
      if (websocket.readyState === WebSocket.OPEN) {
        websocket.close();
      }
    };
  }, []);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  const handleSend = async () => {
    if (!input.trim() || !ws) {
      console.log('Cannot send message:', {
        inputEmpty: !input.trim(),
        wsNull: !ws,
        wsState: ws?.readyState
      });
      return;
    }

    console.log('Preparing to send message:', input);
    console.log('WebSocket state:', ws.readyState);

    const userMessage: Message = {
      id: Date.now().toString(),
      content: input,
      sender: 'user',
      timestamp: new Date()
    };

    setMessages(prev => [...prev, userMessage]);
    setInput('');
    setIsLoading(true);

    try {
      const messageData = {
        message: input,
        timestamp: new Date().toISOString()
      };
      console.log('Sending message data:', messageData);
      ws.send(JSON.stringify(messageData));
      console.log('Message sent successfully');
    } catch (error) {
      console.error('Error sending message:', error);
      setIsLoading(false);
    }
  };

  const handleKeyPress = (event: React.KeyboardEvent) => {
    if (event.key === 'Enter' && !event.shiftKey) {
      event.preventDefault();
      handleSend();
    }
  };

  return (
    <Box sx={{ height: '100%', display: 'flex', flexDirection: 'column', p: 2 }}>
      <Paper 
        elevation={3} 
        sx={{ 
          flex: 1, 
          mb: 2, 
          p: 2, 
          overflow: 'auto',
          maxHeight: 'calc(100vh - 200px)',
          bgcolor: 'background.default'
        }}
      >
        {messages.map((message) => (
          <Box
            key={message.id}
            sx={{
              display: 'flex',
              justifyContent: message.sender === 'user' ? 'flex-end' : 'flex-start',
              mb: 2
            }}
          >
            <Paper
              elevation={1}
              sx={{
                p: 2,
                maxWidth: '70%',
                bgcolor: message.sender === 'user' ? 'primary.light' : 'background.paper',
                color: message.sender === 'user' ? 'primary.contrastText' : 'text.primary'
              }}
            >
              <Typography variant="body1" sx={{ whiteSpace: 'pre-wrap' }}>
                {message.content}
              </Typography>
              <Typography variant="caption" sx={{ opacity: 0.7 }}>
                {new Date(message.timestamp).toLocaleTimeString()}
              </Typography>
            </Paper>
          </Box>
        ))}
        {isLoading && (
          <Box sx={{ display: 'flex', justifyContent: 'flex-start', mb: 2 }}>
            <CircularProgress size={20} />
          </Box>
        )}
        <div ref={messagesEndRef} />
      </Paper>
      <Box sx={{ display: 'flex', gap: 1 }}>
        <TextField
          fullWidth
          multiline
          maxRows={4}
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyPress={handleKeyPress}
          placeholder="Type your message..."
          variant="outlined"
          disabled={isLoading}
        />
        <Button
          variant="contained"
          onClick={handleSend}
          disabled={!input.trim() || isLoading}
          sx={{ minWidth: '100px' }}
        >
          <SendIcon />
        </Button>
      </Box>
    </Box>
  );
};

export default ChatWindow; 