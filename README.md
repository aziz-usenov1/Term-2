# Term-2
Linkedin Job Postings

### MongoDB Data Integration Workflow
This section showcases the workflow for transforming, splitting, and integrating large datasets into a MongoDB database. 

**The main tasks include:**
- **CSV to JSON Conversion:** [converter.py](MongoDB%20import/converter.py) 
  - Extracting relevant columns (`company_id` and `description`) from a [company.csv](MongoDB%20import/CSV%20files/companies.csv) file
  - Converting the data into a JSON format suitable for MongoDB
- **JSON Chunking:** [chunking_and_mongodb_importing.py](MongoDB%20import/chunking_and_mongodb_importing.py)
  - Splitting the JSON file into 4 smaller chunks to adhere to MongoDB's 16MB document size limit
    - [companies_part1.json](MongoDB%20import/JSON%20output/companies_part1.json)
    - [companies_part2.json](MongoDB%20import/JSON%20output/companies_part2.json)
    - [companies_part3.json](MongoDB%20import/JSON%20output/companies_part3.json)
    - [companies_part4.json](MongoDB%20import/JSON%20output/companies_part4.json)
- **Data Import to MongoDB:** [chunking_and_mongodb_importing.py](MongoDB%20import/chunking_and_mongodb_importing.py)
  - Importing the data into MongoDB through `from pymongo import MongoClient` library
    - need `connection string` labeled as `client`
    - need `password` within connectin string as `de_2_term_2`
    - need `database name` labeled as `db`
    - need `folder name` labeled as `collection`
- **KNIME Workflow Integration:**
  - Connecting MongoDB to ***KNIME*** for further processing and analysis
    - connect to MongoDB using the `MongoDB Connector` node in KNIME
    - retrieve the data using the `MongoDB Reader` node
    - read the content of a JSON column using the `Container Output (JSON)` node
- **JSON Schema:** [companies.schema.json](MongoDB%20import/JSON%20Schema/companies.schema.json)
  - The schema ensures each JSON document adheres to the following structure:
    - **Root Type:** Array, containing objects.
    - **Object Properties:**
      - `company_id` (*string*): Unique identifier for each company.
      - `description` (*string*): Textual description of the company.
    - **Required Fields:**
      - Each object in the array must include both `company_id` and `description`
