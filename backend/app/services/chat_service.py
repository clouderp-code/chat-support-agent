from typing import Dict
import logging
from openai import AsyncOpenAI
import json
from app.services.vector_store import VectorStore
from ..core.config import settings

# Set up detailed logging
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class ChatService:
    def __init__(self):
        logger.debug("Initializing ChatService")
        self.vector_store = VectorStore()
        self.client = AsyncOpenAI(api_key=settings.OPENAI_API_KEY)
        logger.debug(f"ChatService initialized with API key: {settings.OPENAI_API_KEY[:8]}...")

    async def process_message(
        self,
        session_id: str,
        message: str,
        user_id: str
    ) -> Dict:
        logger.debug(f"Processing message - Session: {session_id}, Message: {message}")
        
        try:
            logger.debug("Preparing OpenAI API call")
            messages = [
                {
                    "role": "system",
                    "content": "You are an AI service desk agent. Provide clear and concise responses."
                },
                {
                    "role": "user",
                    "content": message
                }
            ]
            logger.debug(f"Prepared messages for OpenAI: {json.dumps(messages, indent=2)}")
            
            logger.debug("Making API call to OpenAI")
            response = await self.client.chat.completions.create(
                model="gpt-3.5-turbo",
                messages=messages,
                temperature=0.7,
                max_tokens=500
            )
            logger.debug(f"Received response from OpenAI: {response}")
            
            response_text = response.choices[0].message.content
            logger.debug(f"Extracted response text: {response_text}")

            result = {
                "response": response_text,
                "sources": []
            }
            logger.debug(f"Returning result: {json.dumps(result, indent=2)}")
            return result
            
        except Exception as e:
            logger.exception("Error in process_message")
            return {
                "response": f"I apologize, but I encountered an error: {str(e)}",
                "sources": []
            } 