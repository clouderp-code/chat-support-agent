from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import logging
from app.api.endpoints import chat

# Configure logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

def create_app() -> FastAPI:
    app = FastAPI(
        title="AI Service Desk API",
        description="API for AI-powered service desk",
        version="1.0.0"
    )

    # Configure CORS
    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    # Include chat routes
    app.include_router(chat.router, prefix="/api/chat", tags=["chat"])

    @app.get("/")
    async def root():
        logger.debug("Root endpoint called")
        return {"message": "Hello World"}

    @app.get("/health")
    async def health_check():
        logger.debug("Health check endpoint called")
        return {"status": "healthy"}

    # Log all registered routes on startup
    @app.on_event("startup")
    async def startup_event():
        logger.debug("Registered routes:")
        for route in app.routes:
            if hasattr(route, 'methods'):  # HTTP routes
                logger.debug(f"{route.methods} {route.path}")
            elif hasattr(route, 'path'):   # WebSocket routes
                logger.debug(f"WebSocket {route.path}")
            
    return app

app = create_app() 