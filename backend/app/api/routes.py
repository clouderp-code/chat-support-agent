from fastapi import APIRouter
from .endpoints import chat

api_router = APIRouter()

# Include chat routes with prefix
api_router.include_router(chat.router, prefix="/chat", tags=["chat"]) 