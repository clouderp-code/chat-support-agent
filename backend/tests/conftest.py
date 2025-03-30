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
