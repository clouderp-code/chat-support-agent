from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def get_chat_status():
    return {"status": "Chat service is running"}
