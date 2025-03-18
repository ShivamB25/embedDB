"""
Text embedding example for EmbedDB.

This script demonstrates how to use EmbedDB's text embedding functionality.
To run this example, you'll need to install the embeddings extra:
    pip install embeddb[embeddings]
"""

from embeddb import EmbedDB

# Create a vector database with built-in embedding support
db = EmbedDB()  # Uses all-MiniLM-L6-v2 by default

# Add documents with automatic embedding
documents = [
    "EmbedDB is a lightweight vector database for rapid prototyping.",
    "Vector databases store embeddings for semantic search applications.",
    "Semantic search finds documents based on meaning, not just keywords.",
    "EmbedDB provides a simple API in a single Python file."
]

# Add each document to the database
for i, doc in enumerate(documents):
    db.add_text(f"doc{i}", doc)
    
print(f"Added {len(documents)} documents to the database.\n")

# Perform a search with text query
query = "How can I find similar documents?"
print(f"Query: {query}\n")

results = db.search_text(query, top_k=2)

# Display results
print("Top results:")
for i, result in enumerate(results):
    print(f"{i+1}. {result['metadata']['text']} (Score: {result['similarity']:.4f})")

# Save the database
db.save("text_db.json")
print("\nDatabase saved to text_db.json")

# Example with custom metadata
print("\nAdding a document with custom metadata:")
metadata = {"text": "This is a test document", "category": "test", "tags": ["example", "embeddings"]}
db.add_text("custom_doc", "This is a test document", metadata=metadata)

# Retrieve and display the custom metadata
vector, meta = db.get("custom_doc")
print(f"Retrieved metadata: {meta}") 