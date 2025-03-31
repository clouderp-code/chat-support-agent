from fastapi import APIRouter, WebSocket, WebSocketDisconnect, HTTPException
from openai import AsyncOpenAI
import json
import logging
from ...core.config import settings
from app.services.chat_service import ChatService

# Configure logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

router = APIRouter()

@router.get("/test", status_code=200)
async def test_chat():
    """Test endpoint to verify chat service is working"""
    logger.debug("Test endpoint called")
    return {"message": "Chat service test endpoint working"}

@router.get("/test-openai", status_code=200)
async def test_openai():
    """Test OpenAI integration directly"""
    try:
        logger.debug("Testing OpenAI integration")
        client = AsyncOpenAI(api_key=settings.OPENAI_API_KEY)
        response = await client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "user", "content": "Say hello!"}
            ]
        )
        return {"response": response.choices[0].message.content}
    except Exception as e:
        logger.exception("Error testing OpenAI")
        raise HTTPException(status_code=500, detail=str(e))

@router.websocket("/ws")
async def chat_websocket(websocket: WebSocket):
    logger.debug("WebSocket endpoint called")
    await websocket.accept()
    logger.debug("WebSocket connection accepted")
    
    chat_service = ChatService()
    
    try:
        while True:
            logger.debug("Waiting for message...")
            data = await websocket.receive_text()
            logger.debug(f"Received raw data: {data}")
            
            try:
                message_data = json.loads(data)
                logger.debug(f"Parsed message data: {message_data}")
                message = message_data.get("message", "")
                logger.debug(f"Extracted message: {message}")
                
                if not message:
                    logger.warning("Received empty message")
                    continue
                
            except json.JSONDecodeError as e:
                logger.error(f"JSON decode error: {e}")
                message = data
            
            logger.debug("Processing message with chat service")
            response = await chat_service.process_message(
                session_id=str(websocket.client.host),
                message=message,
                user_id="anonymous"
            )
            logger.debug(f"Chat service response: {response}")
            
            logger.debug("Sending response back to client")
            await websocket.send_json(response)
            logger.debug("Response sent successfully")
            
    except WebSocketDisconnect:
        logger.info("Client disconnected")
    except Exception as e:
        logger.exception("Error in WebSocket handler")
        try:
            await websocket.send_json({
                "response": "I apologize, but I encountered an error. Please try again.",
                "sources": []
            })
        except:
            logger.error("Failed to send error message to client") 