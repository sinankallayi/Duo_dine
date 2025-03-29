#!/bin/bash

PROJECT_ID="67dc5f7e003032d8838b"
DATABASE_ID="67dd045f0027aa53f550"
COLLECTION_ID="67935e14001fe833d665"

# Get all document IDs
DOCUMENTS=$(appwrite databases list-documents --database-id "$DATABASE_ID" --collection-id "$COLLECTION_ID" --json | jq -r '.documents[]."$id"')

# Loop through each document and update status
for DOC_ID in $DOCUMENTS; do
    appwrite databases update-document --database-id "$DATABASE_ID" --collection-id "$COLLECTION_ID" --document-id "$DOC_ID" --data '{"status": "orderPlaced"}'
    echo "Updated document: $DOC_ID"
done

echo "All documents updated successfully."
