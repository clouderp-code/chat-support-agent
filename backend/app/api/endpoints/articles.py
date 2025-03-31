from fastapi import APIRouter, Depends, BackgroundTasks
from typing import List, Dict
from ...services.article_indexer import ArticleIndexer
from ...core.auth import get_current_user
from ...core.config import settings

router = APIRouter()

@router.post("/index")
async def index_articles(
    background_tasks: BackgroundTasks,
    current_user = Depends(get_current_user)
):
    """Start indexing articles from Google Drive"""
    indexer = ArticleIndexer()
    background_tasks.add_task(
        indexer.index_articles,
        settings.ARTICLES_FOLDER_ID
    )
    return {"message": "Article indexing started"}

@router.get("/search")
async def search_articles(
    query: str,
    limit: int = 5,
    current_user = Depends(get_current_user)
) -> List[Dict]:
    """Search articles based on query"""
    indexer = ArticleIndexer()
    results = await indexer.search_articles(query, limit)
    return results 