from typing import List, Dict
import asyncio
from datetime import datetime
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import FAISS
from .google_drive_service import GoogleDriveService
from ..models.article import Article
from ..core.config import settings

class ArticleIndexer:
    def __init__(self):
        self.drive_service = GoogleDriveService()
        self.embeddings = OpenAIEmbeddings()
        self.text_splitter = RecursiveCharacterTextSplitter(
            chunk_size=1000,
            chunk_overlap=200,
            length_function=len
        )
        self.vector_store = None
        self.initialize_vector_store()

    def initialize_vector_store(self):
        try:
            self.vector_store = FAISS.load_local(
                settings.VECTOR_STORE_PATH, 
                self.embeddings
            )
        except:
            self.vector_store = FAISS.from_texts(
                ["initialization"], 
                self.embeddings
            )

    async def index_articles(self, folder_id: str = None) -> List[Dict]:
        """Index all PDF articles from Google Drive folder"""
        pdf_files = await self.drive_service.list_pdf_files(folder_id)
        indexed_articles = []

        for pdf_file in pdf_files:
            article = await self.index_single_article(pdf_file)
            if article:
                indexed_articles.append(article)

        return indexed_articles

    async def index_single_article(self, file_info: Dict) -> Dict:
        """Index a single PDF article"""
        try:
            # Download and extract text from PDF
            content = await self.drive_service.download_pdf(file_info['id'])
            if not content:
                return None

            # Split text into chunks
            chunks = self.text_splitter.split_text(content)

            # Create metadata for each chunk
            metadatas = [{
                "source": file_info['id'],
                "title": file_info['name'],
                "chunk": i,
                "modified": file_info['modifiedTime']
            } for i in range(len(chunks))]

            # Add to vector store
            self.vector_store.add_texts(
                texts=chunks,
                metadatas=metadatas
            )

            # Save vector store
            self.vector_store.save_local(settings.VECTOR_STORE_PATH)

            return {
                "file_id": file_info['id'],
                "title": file_info['name'],
                "modified": file_info['modifiedTime'],
                "chunks": len(chunks)
            }

        except Exception as e:
            print(f"Error indexing article {file_info['name']}: {str(e)}")
            return None

    async def search_articles(self, query: str, limit: int = 5) -> List[Dict]:
        """Search for relevant article chunks"""
        results = self.vector_store.similarity_search_with_score(
            query,
            k=limit
        )

        return [{
            "content": result[0].page_content,
            "metadata": result[0].metadata,
            "score": result[1]
        } for result in results] 