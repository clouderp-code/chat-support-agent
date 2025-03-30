from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def get_kb_status():
    return {"status": "Knowledge base service is running"}
