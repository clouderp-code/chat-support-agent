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
- React.js
- Material-UI
- Redux Toolkit
- WebSocket
- TypeScript

### Infrastructure
- Docker
- Kubernetes
- AWS Services
- Elasticsearch
- Prometheus/Grafana

## 📋 Prerequisites

- Python 3.11.11
- Node.js (Latest LTS)
- Docker and Docker Compose
- Git

## 🔧 Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd ai-service-desk
```

2. Set up environment variables:
```bash
cp .env.example .env
# Edit .env with your configurations
```

3. Start the development environment:
```bash
docker-compose up -d
```

4. Install frontend dependencies:
```bash
cd frontend
npm install
```

5. Install backend dependencies:
```bash
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: .\venv\Scripts\activate
pip install -r requirements.txt
```

## 🚀 Development

### Backend Development

The backend is built with FastAPI and includes:
- RESTful API endpoints in `app/api/v1/`
- Core configuration in `app/core/`
- Database models in `app/models/`
- Business logic in `app/services/`

To run the backend locally:
```bash
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: .\venv\Scripts\activate
pip install -r requirements.txt
uvicorn main:app --reload
```

### Frontend Development

The frontend is built with React and TypeScript:
- Component-based architecture
- Material-UI for styling
- Redux for state management
- WebSocket for real-time communication

To run the frontend locally:
```bash
cd frontend
npm install
npm start
```

## 🧪 Testing

### Backend Tests
```bash
cd backend
./run_tests.sh
```

### Frontend Tests
```bash
cd frontend
npm test
```

## 📚 API Documentation

- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## 🔐 Security Features

- JWT-based authentication
- Role-based access control (RBAC)
- Environment-based configuration
- CORS protection
- Rate limiting
- Input validation

## 🔄 Available Endpoints

### Chat Service
- GET `/api/v1/chat/` - Check chat service status

### Knowledge Base
- GET `/api/v1/kb/` - Check knowledge base service status

### Ticket Management
- GET `/api/v1/tickets/` - Check ticket service status

### Analytics
- GET `/api/v1/analytics/` - Check analytics service status

## 📊 Monitoring

The project includes comprehensive monitoring:
- Prometheus metrics
- Grafana dashboards
- ELK stack for logging
- Real-time performance monitoring

Access monitoring tools:
- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000
- Elasticsearch: http://localhost:9200
- Kibana: http://localhost:5601

## 🚀 Deployment

### Local Development
```bash
docker-compose up -d
```

### Production Deployment
1. Build images:
```bash
docker-compose -f docker-compose.prod.yml build
```

2. Deploy to Kubernetes:
```bash
kubectl apply -f infrastructure/kubernetes/
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Support

For support, please contact [support@example.com](mailto:support@example.com)