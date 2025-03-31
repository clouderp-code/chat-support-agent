import httpx
import asyncio
import logging

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

async def test_endpoints():
    async with httpx.AsyncClient() as client:
        # Test root endpoint
        response = await client.get("http://localhost:8000/")
        logger.debug(f"Root endpoint response: {response.status_code} {response.text}")

        # Test health endpoint
        response = await client.get("http://localhost:8000/health")
        logger.debug(f"Health endpoint response: {response.status_code} {response.text}")

        # Test chat test endpoint
        response = await client.get("http://localhost:8000/api/chat/test")
        logger.debug(f"Chat test endpoint response: {response.status_code} {response.text}")

        # Test OpenAI test endpoint
        response = await client.get("http://localhost:8000/api/chat/test-openai")
        logger.debug(f"OpenAI test endpoint response: {response.status_code} {response.text}")

if __name__ == "__main__":
    asyncio.run(test_endpoints()) 