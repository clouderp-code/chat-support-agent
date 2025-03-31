import sys
import os
import asyncio
from dotenv import load_dotenv
from openai import AsyncOpenAI

# Load environment variables from .env file
load_dotenv()

async def test_openai_integration():
    try:
        # Get API key from environment
        api_key = os.getenv('OPENAI_API_KEY')
        if not api_key:
            print("Error: OPENAI_API_KEY not found in environment variables")
            return

        print(f"Using API key: {api_key[:8]}...")
        
        # Initialize the client with the API key
        client = AsyncOpenAI(api_key=api_key)

        # Test API call
        print("Making test API call to OpenAI...")
        response = await client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": "You are a helpful assistant."},
                {"role": "user", "content": "Hello, this is a test message. Please respond with a short greeting."}
            ],
            temperature=0.7,
            max_tokens=150
        )

        # Print response details
        print("\nAPI Response Details:")
        print(f"Response ID: {response.id}")
        print(f"Model Used: {response.model}")
        print(f"Response Content: {response.choices[0].message.content}")
        print("\nAPI call successful!")

    except Exception as e:
        print(f"\nError occurred: {str(e)}")
        print("\nFull error details:")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    print("Starting OpenAI API test...")
    asyncio.run(test_openai_integration()) 