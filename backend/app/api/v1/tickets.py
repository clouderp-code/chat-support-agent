from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def get_tickets_status():
    return {"status": "Ticket service is running"}
