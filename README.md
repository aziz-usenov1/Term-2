# Term-2
Linkedin Job Postings

### MongoDB Data Integration Workflow
This section showcases the workflow for transforming, splitting, and integrating large datasets into a MongoDB database. 

**The main tasks include:**

- Extracting relevant columns (`company_id` and `description`) from a [company.csv](Term-2/MongoDB%20import/csv%20files/companies.csv) file.
- Converting the data into a JSON format suitable for MongoDB.
- Splitting the JSON file into smaller chunks to adhere to MongoDB's 16MB document size limit.
- Importing the data into MongoDB.
- Connecting MongoDB to KNIME for further processing and analysis.
