from typing import List, Dict
import redis
import json
from datetime import datetime
from ...core.config import settings

class ChatMemory:
    def __init__(self):
        self.redis_client = redis.Redis(
            host=settings.REDIS_HOST,
            port=settings.REDIS_PORT,
            db=0,
            decode_responses=True
        )
        self.memory_key_prefix = "chat_memory:"
        self.memory_ttl = 3600 * 24  # 24 hours

    def add_message(self, session_id: str, message: Dict):
        key = f"{self.memory_key_prefix}{session_id}"
        
        # Get existing messages
        messages = self.get_messages(session_id)
        
        # Add timestamp to message
        message["timestamp"] = datetime.utcnow().isoformat()
        
        # Append new message
        messages.append(message)
        
        # Keep only last N messages
        if len(messages) > settings.MAX_CHAT_MEMORY:
            messages = messages[-settings.MAX_CHAT_MEMORY:]
        
        # Store updated messages
        self.redis_client.set(
            key,
            json.dumps(messages),
            ex=self.memory_ttl
        )

    def get_messages(self, session_id: str) -> List[Dict]:
        key = f"{self.memory_key_prefix}{session_id}"
        messages_json = self.redis_client.get(key)
        
        if messages_json:
            return json.loads(messages_json)
        return []

    def clear_memory(self, session_id: str):
        key = f"{self.memory_key_prefix}{session_id}"
        self.redis_client.delete(key) 