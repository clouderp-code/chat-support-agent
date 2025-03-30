#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Print colored message
print_message() {
    echo -e "${BLUE}[Setup] ${GREEN}$1${NC}"
}

print_error() {
    echo -e "${BLUE}[Setup] ${RED}$1${NC}"
}

# Check Python version
check_python_version() {
    print_message "Checking Python version..."
    
    if ! command -v python3.11 &> /dev/null; then
        print_error "Python 3.11 is required but not installed."
        exit 1
    fi
    
    PYTHON_VERSION=$(python3.11 -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')
    if [[ "$PYTHON_VERSION" != "3.11.11" ]]; then
        print_error "Python 3.11.11 is required, but found $PYTHON_VERSION"
        exit 1
    fi
    
    print_message "Python version check passed: $PYTHON_VERSION"
}

# Check other prerequisites
check_prerequisites() {
    print_message "Checking prerequisites..."
    
    if ! command -v node &> /dev/null; then
        print_error "Node.js is required but not installed."
        exit 1
    fi
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker is required but not installed."
        exit 1
    fi
    
    if ! command -v git &> /dev/null; then
        print_error "Git is required but not installed."
        exit 1
    fi
}

# Add this new function after check_prerequisites() and before create_project_structure()

setup_docker_compose() {
    print_message "Checking Docker Compose installation..."
    
    if ! command -v docker-compose &> /dev/null; then
        print_message "Docker Compose not found. Installing..."
        
        # Fix apt_pkg issue if it exists
        if [ -f "/usr/bin/apt" ]; then
            print_message "Fixing potential apt_pkg issue..."
            sudo apt-get update
            sudo apt-get install -y python3-apt apt-utils
        fi
        
        # Install Docker Compose
        sudo curl -L "https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        
        if ! command -v docker-compose &> /dev/null; then
            print_error "Failed to install Docker Compose"
            exit 1
        fi
    fi
    
    print_message "Docker Compose is available: $(docker-compose --version)"
}

# Project root directory
# PROJECT_ROOT="ai-service-desk"
PROJECT_ROOT="."

# Create project structure
create_project_structure() {
    print_message "Creating project structure..."
    
    # Create main project directory
    mkdir -p $PROJECT_ROOT
    cd $PROJECT_ROOT

    # Backend structure
    mkdir -p backend/{app,tests,scripts,docs}
    mkdir -p backend/app/{api,core,models,schemas,services,utils}
    mkdir -p backend/app/api/{v1,websocket}
    mkdir -p backend/app/core/{auth,config,logging,security}
    mkdir -p backend/app/models/{chat,knowledge,ticket,user}
    mkdir -p backend/app/services/{agent,analytics,email,knowledge}
    mkdir -p backend/tests/{unit,integration,e2e}
    
    # Frontend structure
    mkdir -p frontend/{src,public,tests}
    mkdir -p frontend/src/{components,pages,services,store,hooks,utils,types}
    mkdir -p frontend/src/components/{Chat,Dashboard,KnowledgeBase,Common,Tickets}
    mkdir -p frontend/src/store/{slices,middleware}
    
    # Infrastructure
    mkdir -p infrastructure/{terraform,kubernetes,monitoring,scripts}
    mkdir -p infrastructure/kubernetes/{base,overlays}/{backend,frontend,monitoring}
    mkdir -p infrastructure/monitoring/{prometheus,grafana,elasticsearch,fluentd,kibana}
    
    # Documentation
    mkdir -p docs/{api,architecture,deployment,development}
}

# Create backend files
create_backend_files() {
    print_message "Creating backend files..."
    
    # Create requirements.txt with Python 3.11.11 compatible versions
    cat << 'EOF' > backend/requirements.txt
# Core dependencies
fastapi==0.104.1
uvicorn[standard]==0.24.0
pydantic==2.4.2
pydantic-settings==2.0.3

# Database
sqlalchemy==2.0.23
alembic==1.12.1
psycopg2-binary==2.9.9
redis==5.0.1
aioredis==2.0.1

# AI/ML
openai==1.2.3
langchain==0.0.330
pinecone-client==2.2.4

# Security
python-jose[cryptography]==3.3.0
passlib[bcrypt]==1.7.4
python-multipart==0.0.6

# Testing
pytest==7.4.3
pytest-asyncio==0.21.1
pytest-cov==4.1.0
httpx==0.25.1

# Utils
websockets==12.0
PyYAML==6.0.1
python-dotenv==1.0.0
tenacity==8.2.3
structlog==23.2.0

# AWS
boto3==1.29.3
botocore==1.32.3
EOF

    # Create main application file
    cat << 'EOF' > backend/main.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.api.v1 import chat, knowledge_base, tickets, analytics
from app.core.logging import setup_logging

app = FastAPI(
    title="AI Service Desk",
    description="AI-Powered Service Desk Agent",
    version="1.0.0"
)

setup_logging()

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {"message": "Welcome to AI Service Desk API"}

# Include routers
app.include_router(chat, prefix="/api/v1/chat", tags=["chat"])
app.include_router(knowledge_base, prefix="/api/v1/kb", tags=["knowledge-base"])
app.include_router(tickets, prefix="/api/v1/tickets", tags=["tickets"])
app.include_router(analytics, prefix="/api/v1/analytics", tags=["analytics"])

@app.on_event("startup")
async def startup_event():
    # Initialize services
    pass

@app.on_event("shutdown")
async def shutdown_event():
    # Cleanup resources
    pass
EOF
}

# Create frontend files
create_frontend_files() {
    print_message "Creating frontend files..."
    
    # Create necessary directories
    mkdir -p frontend/src/pages
    mkdir -p frontend/src/components/Layout
    mkdir -p frontend/src/components/Chat
    mkdir -p frontend/src/components/Dashboard
    
    # Create ArticleDetailPage.tsx in the correct location
    cat << 'EOF' > frontend/src/pages/ArticleDetailPage.tsx
import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
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
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState('');

  const filteredArticles = articles.filter(article =>
    article.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
    article.category.toLowerCase().includes(searchTerm.toLowerCase()) ||
    article.excerpt.toLowerCase().includes(searchTerm.toLowerCase())
  );

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
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          InputProps={{
            startAdornment: <SearchIcon sx={{ mr: 1, color: 'text.secondary' }} />,
          }}
        />
      </Box>

      <Grid container spacing={3}>
        {filteredArticles.map((article) => (
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
                <Button 
                  size="small" 
                  color="primary"
                  onClick={() => navigate(`/knowledge/article/${article.id}`)}
                >
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
EOF

    # Create other files in their correct locations
    cat << 'EOF' > frontend/src/pages/HomePage.tsx
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
EOF

    cat << 'EOF' > frontend/src/pages/ChatPage.tsx
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
EOF

    # Update the Dockerfile to handle the file structure correctly
    cat << 'EOF' > frontend/Dockerfile
# Build stage
FROM node:16-alpine as build

WORKDIR /app

# Copy package files and config
COPY package*.json ./
COPY tsconfig.json ./

# Install dependencies
RUN npm install

# Copy the source code
COPY public/ public/
COPY src/ src/

# Build the application
RUN npm run build

# Production stage
FROM nginx:alpine

# Copy built assets from build stage
COPY --from=build /app/build /usr/share/nginx/html

# Copy nginx configuration if needed
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
EOF

    # Create a .dockerignore file
    cat << 'EOF' > frontend/.dockerignore
node_modules
build
.git
.gitignore
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
npm-debug.log*
yarn-debug.log*
yarn-error.log*
EOF

    print_message "Created frontend files with proper structure"
}

# Create infrastructure files
create_infrastructure_files() {
    print_message "Creating infrastructure files..."
    
    # Create docker-compose.yml
    cat << 'EOF' > docker-compose.yml
version: '3.8'

services:
  backend:
    build: 
      context: ./backend
      dockerfile: Dockerfile
    ports:
      - "8000:8000"
    environment:
      - POSTGRES_SERVER=db
      - REDIS_HOST=redis
    env_file:
      - .env
    depends_on:
      - db
      - redis

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    ports:
      - "3000:80"
    environment:
      - REACT_APP_API_URL=http://localhost:8000
    depends_on:
      - backend

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
      - POSTGRES_DB=${POSTGRES_DB}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.10.4
    environment:
      - discovery.type=single-node
    ports:
      - "9200:9200"
    volumes:
      - elasticsearch_data:/usr/share/elasticsearch/data

volumes:
  postgres_data:
  redis_data:
  elasticsearch_data:
EOF
}

# Create Dockerfiles
create_docker_files() {
    print_message "Creating Dockerfiles..."
    
    # Create backend Dockerfile with proper file structure
    cat << 'EOF' > backend/Dockerfile
FROM python:3.11.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    postgresql-client \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Create and activate virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -U pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY main.py .
COPY app app/
COPY tests tests/

# Set Python path
ENV PYTHONPATH=/app

# Expose the port the app runs on
EXPOSE 8000

# Command to run the application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
EOF

    # Create frontend Dockerfile with improved dependency handling
    cat << 'EOF' > frontend/Dockerfile
# Build stage
FROM node:16-alpine as build

WORKDIR /app

# Copy package files and npm configuration
COPY package*.json .npmrc ./
COPY tsconfig.json ./

# Install dependencies with specific steps
RUN npm cache clean --force && \
    npm install && \
    npm install ajv@6.12.6 ajv-keywords@3.5.2 schema-utils@3.1.2 --save-exact

# Copy the rest of the application
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM nginx:alpine

# Copy built assets from build stage
COPY --from=build /app/build /usr/share/nginx/html

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
EOF

    # Create a basic nginx configuration file
    cat << 'EOF' > frontend/nginx.conf
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

    # Support for Single Page Application
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Optional: Add security headers
    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";
}
EOF

    print_message "Created Dockerfiles for backend and frontend"
}

# Create environment and git configuration files
create_env_files() {
    print_message "Creating environment and git configuration files..."
    
    # Create .env.example file
    cat << 'EOF' > .env.example
# Application Settings
APP_ENV=development
APP_DEBUG=true
APP_SECRET_KEY=your-super-secret-key-change-this

# API Configuration
API_VERSION=v1
API_PREFIX=/api
CORS_ORIGINS=["http://localhost:3000","http://localhost:8000"]

# Database Configuration
POSTGRES_SERVER=localhost
POSTGRES_PORT=5432
POSTGRES_DB=ai_service_desk
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_secure_password
DATABASE_URL=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_SERVER}:${POSTGRES_PORT}/${POSTGRES_DB}

# Redis Configuration
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=
REDIS_DB=0

# OpenAI Configuration
OPENAI_API_KEY=your-openai-api-key
OPENAI_MODEL=gpt-4
OPENAI_TEMPERATURE=0.7
OPENAI_MAX_TOKENS=2000

# LangChain Configuration
LANGCHAIN_VERBOSE=true
LANGCHAIN_DEBUG=false

# Pinecone Configuration
PINECONE_API_KEY=your-pinecone-api-key
PINECONE_ENVIRONMENT=us-west1-gcp
PINECONE_INDEX_NAME=service-desk-kb

# JWT Settings
JWT_SECRET_KEY=your-jwt-secret-key-change-this
JWT_ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
REFRESH_TOKEN_EXPIRE_DAYS=7

# Email Configuration
SMTP_TLS=true
SMTP_PORT=587
SMTP_HOST=smtp.gmail.com
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=your-app-specific-password

# AWS Configuration
AWS_ACCESS_KEY_ID=your-aws-access-key
AWS_SECRET_ACCESS_KEY=your-aws-secret-key
AWS_REGION=us-west-2
AWS_S3_BUCKET=your-bucket-name

# Monitoring and Logging
LOG_LEVEL=INFO
ELASTICSEARCH_HOST=localhost
ELASTICSEARCH_PORT=9200
PROMETHEUS_METRICS_PORT=9090

# Frontend Configuration
REACT_APP_API_URL=http://localhost:8000
REACT_APP_WS_URL=ws://localhost:8000/ws
REACT_APP_ENVIRONMENT=development

# Security Settings
SECURITY_BCRYPT_ROUNDS=12
SECURITY_PASSWORD_SALT=your-password-salt
SECURITY_RESET_TOKEN_EXPIRE_HOURS=24
SECURITY_VERIFICATION_TOKEN_EXPIRE_MINUTES=10

# Rate Limiting
RATE_LIMIT_ENABLED=true
RATE_LIMIT_REQUESTS_PER_MINUTE=60

# Cache Configuration
CACHE_TYPE=redis
CACHE_EXPIRE_MINUTES=15

# Feature Flags
FEATURE_ANALYTICS_ENABLED=true
FEATURE_KNOWLEDGE_BASE_ENABLED=true
FEATURE_TICKET_SYSTEM_ENABLED=true
EOF

    # Create .gitignore file
    cat << 'EOF' > .gitignore
# Environment variables
.env
.env.local
.env.*.local

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST
.pytest_cache/
.coverage
htmlcov/
.venv
venv/

# Node
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.pnpm-debug.log*
.npm
.env.development.local
.env.test.local
.env.production.local

# IDEs and editors
.idea/
.vscode/
*.swp
*.swo
.DS_Store
Thumbs.db

# Project specific
/frontend/build/
/frontend/coverage/
/backend/static/
/backend/media/

# Logs
logs/
*.log

# Docker
.docker/
docker-compose.override.yml

# Database
*.sqlite3
*.db

# Terraform
.terraform/
*.tfstate
*.tfstate.*
*.tfvars

# Kubernetes
kubeconfig
EOF

    # Create initial .env file from .env.example
    cp .env.example .env
    
    print_message "Created .env.example, .env, and .gitignore files"
}

# Create README.md file
create_readme_file() {
    print_message "Creating README.md file..."
    
    cat << 'EOF' > README.md
# AI-Powered Service Desk Agent

An intelligent customer support system leveraging modern AI capabilities to provide 24/7 automated assistance while maintaining context and accessing a comprehensive knowledge base.

## 🚀 Features

- Natural language understanding and processing
- Context-aware conversations with memory retention
- Knowledge base integration and management
- Multi-turn dialogue handling
- Automated ticket creation and routing
- Analytics and reporting dashboard
- Real-time chat interface
- Admin dashboard for system management

## 🛠️ Tech Stack

### Backend
- Python 3.11.11
- FastAPI
- LangChain
- PostgreSQL
- Redis
- Pinecone
- OpenAI GPT-4

### Frontend
- React.js 18
- Material-UI
- Redux Toolkit
- WebSocket
- TypeScript 4.9.5

### Infrastructure
- Docker & Docker Compose
- Kubernetes
- AWS Services
- Elasticsearch
- Prometheus/Grafana

## 📋 Project Structure

EOF
}

# Set up Python virtual environment
setup_python_env() {
    print_message "Setting up Python virtual environment..."
    
    cd backend
    python3.11 -m venv venv
    source venv/bin/activate
    
    print_message "Installing Python dependencies..."
    pip install --upgrade pip wheel setuptools
    pip install -r requirements.txt
    
    cd ..
}

# Add this new function to create a test script

create_test_script() {
    print_message "Creating test script..."
    
    cat << 'EOF' > backend/run_tests.sh
#!/bin/bash

# Run tests in Docker with PYTHONPATH set
docker build -t backend-tests -f Dockerfile .
docker run --rm -e PYTHONPATH=/app backend-tests pytest
EOF

    # Make the script executable
    chmod +x backend/run_tests.sh
    
    print_message "Created test script"
}

# Add this new function to create initial test files

create_test_files() {
    print_message "Creating test files..."
    
    # Create test_main.py for basic API tests
    cat << 'EOF' > backend/tests/unit/test_main.py
import pytest
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_read_main():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Welcome to AI Service Desk API"}
EOF

    # Create conftest.py for shared test fixtures
    cat << 'EOF' > backend/tests/conftest.py
import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

from app.core.config import Settings
from main import app

@pytest.fixture
def test_client():
    return TestClient(app)

@pytest.fixture
def test_settings():
    return Settings()
EOF

    # Create pytest.ini for test configuration
    cat << 'EOF' > backend/pytest.ini
[pytest]
testpaths = tests
python_files = test_*.py
python_classes = Test*
python_functions = test_*
addopts = -v -s --cov=app --cov-report=term-missing
EOF

    print_message "Created test files"
}

# Add this function to create __init__.py files

create_init_files() {
    print_message "Creating __init__.py files..."
    
    # Create __init__.py files in all Python packages
    touch backend/app/__init__.py
    touch backend/app/api/__init__.py
    touch backend/app/api/v1/__init__.py
    touch backend/app/core/__init__.py
    touch backend/app/models/__init__.py
    touch backend/app/schemas/__init__.py
    touch backend/app/services/__init__.py
    touch backend/app/utils/__init__.py
    touch backend/tests/__init__.py
    touch backend/tests/unit/__init__.py
    touch backend/tests/integration/__init__.py
    touch backend/tests/e2e/__init__.py
}

# Add core config file
create_core_files() {
    print_message "Creating core files..."
    
    # Create config.py with proper imports
    cat << 'EOF' > backend/app/core/config.py
from typing import List
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    # API Configuration
    API_V1_STR: str = "/api/v1"
    PROJECT_NAME: str = "AI Service Desk"
    
    # CORS Configuration
    CORS_ORIGINS: List[str] = ["http://localhost:3000", "http://localhost:8000"]
    
    # Database Configuration
    POSTGRES_SERVER: str = "localhost"
    POSTGRES_PORT: str = "5432"
    POSTGRES_DB: str = "ai_service_desk"
    POSTGRES_USER: str = "postgres"
    POSTGRES_PASSWORD: str = ""
    
    class Config:
        case_sensitive = True
        env_file = ".env"

# Create settings instance
settings = Settings()
EOF

    # Update main.py to use settings instance
    cat << 'EOF' > backend/main.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.api.v1 import chat, knowledge_base, tickets, analytics
from app.core.logging import setup_logging

app = FastAPI(
    title="AI Service Desk",
    description="AI-Powered Service Desk Agent",
    version="1.0.0"
)

setup_logging()

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {"message": "Welcome to AI Service Desk API"}

# Include routers
app.include_router(chat, prefix="/api/v1/chat", tags=["chat"])
app.include_router(knowledge_base, prefix="/api/v1/kb", tags=["knowledge-base"])
app.include_router(tickets, prefix="/api/v1/tickets", tags=["tickets"])
app.include_router(analytics, prefix="/api/v1/analytics", tags=["analytics"])

@app.on_event("startup")
async def startup_event():
    # Initialize services
    pass

@app.on_event("shutdown")
async def shutdown_event():
    # Cleanup resources
    pass
EOF

    print_message "Created core files"
}

# Update the API router files with correct exports

create_api_files() {
    print_message "Creating API router files..."
    
    # Create chat router
    cat << 'EOF' > backend/app/api/v1/chat.py
from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def get_chat_status():
    return {"status": "Chat service is running"}
EOF

    # Create knowledge_base router
    cat << 'EOF' > backend/app/api/v1/knowledge_base.py
from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def get_kb_status():
    return {"status": "Knowledge base service is running"}
EOF

    # Create tickets router
    cat << 'EOF' > backend/app/api/v1/tickets.py
from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def get_tickets_status():
    return {"status": "Ticket service is running"}
EOF

    # Create analytics router
    cat << 'EOF' > backend/app/api/v1/analytics.py
from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def get_analytics_status():
    return {"status": "Analytics service is running"}
EOF

    # Update __init__.py for v1 package with direct exports
    cat << 'EOF' > backend/app/api/v1/__init__.py
from .chat import router as chat
from .knowledge_base import router as knowledge_base
from .tickets import router as tickets
from .analytics import router as analytics
EOF

    print_message "Created API router files"
}

# Main execution
main() {
    check_python_version
    check_prerequisites
    setup_docker_compose
    create_project_structure
    create_backend_files
    create_frontend_files
    create_infrastructure_files
    create_docker_files
    create_init_files
    create_core_files
    create_api_files
    create_test_files
    create_test_script
    create_env_files
    create_readme_file
    setup_python_env
    
    print_message "Project created successfully!"
    print_message "Next steps:"
    print_message "1. cd $PROJECT_ROOT"
    print_message "2. Update values in .env file with your secure credentials"
    print_message "3. Install frontend dependencies: cd frontend && npm install"
    print_message "4. Start development environment: docker-compose up -d"
    print_message "5. Run backend tests: cd backend && ./run_tests.sh"
}

# Run the script
main 