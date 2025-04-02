import os
import requests
from dotenv import load_dotenv  # Import dotenv

# Load environment variables from .env file
load_dotenv()

API_KEY = os.getenv("API_KEY")
PROJECT_ID = os.getenv("PROJECT_ID")


ENDPOINT = "https://cloud.appwrite.io/v1"  # Change if self-hosted
headers = {
    "X-Appwrite-Project": PROJECT_ID,
    "X-Appwrite-Key": API_KEY
}

def delete_all_users():
    while True:
        # Fetch all users
        response = requests.get(f"{ENDPOINT}/users", headers=headers)
        users = response.json().get("users", [])

        if not users:
            print("No more users to delete.")
            break  # Exit when there are no users left

        for user in users:
            user_id = user["$id"]
            del_response = requests.delete(f"{ENDPOINT}/users/{user_id}", headers=headers)
            if del_response.status_code == 204:
                print(f"Deleted user: {user_id}")
            else:
                print(f"Failed to delete user: {user_id}")

delete_all_users()
