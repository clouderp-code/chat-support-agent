from typing import List
import numpy as np
from sentence_transformers import SentenceTransformer
from pymilvus import connections, Collection, FieldSchema, CollectionSchema, DataType, utility
from app.core.config import settings

class VectorStore:
    def __init__(self):
        self.model = SentenceTransformer('all-MiniLM-L6-v2')
        self.collection_name = "articles_store"
        
        # Connect to Milvus
        connections.connect(
            alias="default",
            host=settings.MILVUS_HOST,
            port=settings.MILVUS_PORT
        )
        
        # Create collection if it doesn't exist
        self._create_collection()

    def _create_collection(self):
        if not utility.has_collection(self.collection_name):
            fields = [
                FieldSchema(name="id", dtype=DataType.INT64, is_primary=True),
                FieldSchema(name="article_id", dtype=DataType.INT64),
                FieldSchema(name="content", dtype=DataType.VARCHAR, max_length=65535),
                FieldSchema(name="vector", dtype=DataType.FLOAT_VECTOR, dim=384)
            ]
            schema = CollectionSchema(fields=fields, description="Article vectors")
            Collection(name=self.collection_name, schema=schema)

    def add_article(self, article_id: int, content: str):
        collection = Collection(self.collection_name)
        
        # Split content into chunks
        chunks = self._chunk_text(content)
        vectors = self.model.encode(chunks)
        
        # Prepare data for insertion
        entities = [
            [i for i in range(len(chunks))],  # id
            [article_id] * len(chunks),        # article_id
            chunks,                            # content
            vectors.tolist()                   # vector
        ]
        
        collection.insert(entities)
        collection.flush()

    def search_similar(self, query: str, limit: int = 5) -> List[dict]:
        collection = Collection(self.collection_name)
        collection.load()
        
        # Generate query vector
        query_vector = self.model.encode([query])[0]
        
        # Search
        search_params = {"metric_type": "L2", "params": {"nprobe": 10}}
        results = collection.search(
            data=[query_vector],
            anns_field="vector",
            param=search_params,
            limit=limit,
            output_fields=["article_id", "content"]
        )
        
        return [
            {
                "article_id": hit.entity.get("article_id"),
                "content": hit.entity.get("content"),
                "score": hit.score
            }
            for hit in results[0]
        ]

    def _chunk_text(self, text: str, chunk_size: int = 500) -> List[str]:
        words = text.split()
        chunks = []
        current_chunk = []
        current_size = 0
        
        for word in words:
            current_chunk.append(word)
            current_size += len(word) + 1
            
            if current_size >= chunk_size:
                chunks.append(" ".join(current_chunk))
                current_chunk = []
                current_size = 0
        
        if current_chunk:
            chunks.append(" ".join(current_chunk))
            
        return chunks 