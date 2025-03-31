from typing import List, Optional
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
    
    # Vector store settings
    MILVUS_HOST: str = "localhost"
    MILVUS_PORT: int = 19530
    
    # Redis settings
    REDIS_HOST: str = "localhost"
    REDIS_PORT: int = 6379
    
    # Chat settings
    MAX_CHAT_MEMORY: int = 50
    OPENAI_API_KEY: str
    
    # Google Drive settings
    GOOGLE_DRIVE_CREDENTIALS: str  # JSON string of service account credentials
    GOOGLE_DRIVE_FOLDER_ID: str
    
    class Config:
        case_sensitive = True
        env_file = ".env"

# Create settings instance
settings = Settings()
