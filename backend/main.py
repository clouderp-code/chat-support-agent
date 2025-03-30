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
