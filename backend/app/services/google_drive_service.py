from google.oauth2.credentials import Credentials
from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaIoBaseDownload
import io
import json
from typing import List, Optional
import fitz  # PyMuPDF
from ..core.config import settings

class GoogleDriveService:
    def __init__(self):
        self.creds = self._get_credentials_from_env()
        self.service = build('drive', 'v3', credentials=self.creds)
        self.articles_folder_id = settings.GOOGLE_DRIVE_FOLDER_ID

    def _get_credentials_from_env(self) -> Credentials:
        """Create credentials from environment variables."""
        try:
            # Parse the JSON string from environment variable
            service_account_info = json.loads(settings.GOOGLE_DRIVE_CREDENTIALS)
            
            # Create credentials from service account info
            credentials = service_account.Credentials.from_service_account_info(
                service_account_info,
                scopes=['https://www.googleapis.com/auth/drive.readonly']
            )
            
            return credentials
            
        except Exception as e:
            raise Exception(f"Failed to create credentials from environment: {e}")

    async def list_pdf_files(self) -> List[dict]:
        """List all PDF files in the articles folder."""
        try:
            results = self.service.files().list(
                q=f"'{self.articles_folder_id}' in parents and mimeType='application/pdf'",
                fields="files(id, name, modifiedTime)"
            ).execute()
            
            return results.get('files', [])
        except Exception as e:
            print(f"Error listing files: {e}")
            return []

    async def read_pdf_content(self, file_id: str) -> Optional[str]:
        """Download and read content from a PDF file."""
        try:
            request = self.service.files().get_media(fileId=file_id)
            file = io.BytesIO()
            downloader = MediaIoBaseDownload(file, request)
            
            done = False
            while done is False:
                status, done = downloader.next_chunk()
            
            file.seek(0)
            
            # Read PDF content using PyMuPDF
            pdf_content = ""
            with fitz.open(stream=file.read(), filetype="pdf") as doc:
                for page in doc:
                    pdf_content += page.get_text()
            
            return pdf_content
        except Exception as e:
            print(f"Error reading PDF: {e}")
            return None 