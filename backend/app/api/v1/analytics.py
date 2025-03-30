from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def get_analytics_status():
    return {"status": "Analytics service is running"}
