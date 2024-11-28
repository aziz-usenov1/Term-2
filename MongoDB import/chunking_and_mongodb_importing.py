# Install 'pip install pymongo'

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
# password is hidden
client = MongoClient("mongodb+srv://azizusenov1:<password>@cluster0.osgak.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0")
db = client['linkedin_companies']
collection_companies = db['companies']
collection_skills = db['skills']

# Upload JSON data

# Single JSON to collection: skills description to be uploaded to skills collection
def upload_single_file(filename):
    with open(filename, 'r') as f:
        data = json.load(f)
    collection_skills.insert_many(data)
    print(f"Single JSON file {filename} has been uploaded to MongoDB.")

filename = 'skills.json'
upload_single_file(filename)

# Multiple JSON to collection: company description to be uploaded to companies collection
def upload_multiple_files(file_list):
    for filename in file_list:
        with open(filename, 'r') as f:
            data = json.load(f)
        collection_companies.insert_many(data)
        print(f"Data from {filename} has been uploaded to MongoDB.")

file_list = [
    'companies_part1.json',
    'companies_part2.json',
    'companies_part3.json',
    'companies_part4.json',
]

upload_multiple_files(file_list)
