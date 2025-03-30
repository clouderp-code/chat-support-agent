import React from 'react';
import { ThemeProvider, createTheme } from '@mui/material/styles';
import CssBaseline from '@mui/material/CssBaseline';

const theme = createTheme({
  palette: {
    mode: 'light',
  },
});

function App() {
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <div>
        <h1>AI Service Desk</h1>
        <p>Welcome to the AI-Powered Service Desk Agent</p>
      </div>
    </ThemeProvider>
  );
}

export default App;
