import httpx
import asyncio
import logging
import os
import time

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

async def test_endpoints():
    # Determine if we're running inside Docker
    in_docker = os.environ.get('DOCKER_ENV') == '1'
    base_url = "http://backend:8000" if in_docker else "http://localhost:8000"
    
    logger.debug(f"Testing with base URL: {base_url}")
    logger.debug(f"Running inside Docker: {in_docker}")
    
    # Add retry logic
    max_retries = 5
    retry_delay = 2
    
    async with httpx.AsyncClient() as client:
        for attempt in range(max_retries):
            try:
                endpoints = [
                    "/",
                    "/health",
                    "/api/chat/test",
                    "/api/chat/test-openai"
                ]
                
                for endpoint in endpoints:
                    url = f"{base_url}{endpoint}"
                    logger.debug(f"Testing endpoint: {url}")
                    response = await client.get(url, timeout=10.0)
                    logger.debug(f"Response {endpoint}: {response.status_code} {response.text}")
                
                # If we get here, all endpoints worked
                break
                
            except Exception as e:
                if attempt < max_retries - 1:
                    logger.warning(f"Attempt {attempt + 1} failed, retrying in {retry_delay}s: {e}")
                    await asyncio.sleep(retry_delay)
                else:
                    logger.error(f"All attempts failed for {base_url}")
                    raise

if __name__ == "__main__":
    logger.debug("Starting endpoint tests")
    asyncio.run(test_endpoints()) 