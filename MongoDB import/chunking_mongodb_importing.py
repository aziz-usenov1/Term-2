# Install 'pip install pymongo'https://github.com/aziz-usenov1/Term-2/blob/main/chunking.py

from pymongo import MongoClient
import json

# chunking json file into 4
with open('companies.json', 'r') as f:
    data = json.load(f)

# Chunk sizes
chunk_size = len(data) // 4
chunks = [data[i * chunk_size:(i + 1) * chunk_size] for i in range(3)]
chunks.append(data[3 * chunk_size:])

# Saving each chunk as a json file
for idx, chunk in enumerate(chunks):
    with open(f'companies_part{idx + 1}.json', 'w') as f:
        json.dump(chunk, f, indent=4)

print("JSON file has been split into 4 parts.")


# Connect to MongoDB Atlas
client = MongoClient("mongodb+srv://azizusenov1:<password>@cluster0.osgak.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0")
db = client['linkedin_companies']
collection = db['companies']

# Upload JSON data
def upload_multiple_files(file_list):
    for filename in file_list:
        with open(filename, 'r') as f:
            data = json.load(f)
        collection.insert_many(data)
        print(f"Data from {filename} has been uploaded to MongoDB.")

file_list = [
    'companies_part1.json',
    'companies_part2.json',
    'companies_part3.json',
    'companies_part4.json'
]

upload_multiple_files(file_list)
