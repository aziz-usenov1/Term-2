# Term-2
Linkedin Job Postings

### MongoDB Data Integration Workflow
This section showcases the workflow for transforming, splitting, and integrating large datasets into a MongoDB database. 

**The main tasks include:**
- [converter.py](MongoDB%20import/converter.py) 
  - Extracting relevant columns (`company_id` and `description`) from a [company.csv](MongoDB%20import/CSV%20files/companies.csv) file
  - Converting the data into a JSON format suitable for MongoDB
- [chunking.py](MongoDB%20import/chunking.py)
  - Splitting the JSON file into 4 smaller chunks to adhere to MongoDB's 16MB document size limit
  - Importing the data into MongoDB through `from pymongo import MongoClient` library
    - need `connection string` labeled as `client`
    - need `database name` labeled as `db`
    - need `folder name` labeled as `collection`
- Connecting MongoDB to ***KNIME*** for further processing and analysis
  - connect to MongoDB using the `MongoDB Connector` node in KNIME.
  - retrieve the data using the `MongoDB Reader` node.
  - read the content of a JSON column using the `Container Output (JSON)` node. 
