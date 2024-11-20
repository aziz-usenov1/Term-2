<a id="readme-top"></a>

# Term-2
Linkedin Job Postings

<details>
  <summary>Table of Contents</summary>
  <ol>
      <!--Please adjust accordingly by adding content link by adding <li></li> -->
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#mongodb-data-integration-workflow">MongoDB Data Integration Workflow</a>
    </li>
  </ol>
</details>

### About The Project
bla bla bla

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Built With

* ![Python][Python.url]
* ![MongoDB][MongoDB.url]
* ![Azure][Azure.url]
* ![MySQLWorkbench][MySQL.url]
* ![Knime][Knime.url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>

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
    - need `password` within `connectin string` as *de_2_term_2*
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

<p align="right">(<a href="#readme-top">back to top</a>)</p>
     
<!-- MARKDOWN LINKS & IMAGES -->

[MySQL.url]: https://img.shields.io/badge/mysql-4479A1.svg?style=for-the-badge&logo=mysql&logoColor=white
[Python.url]:https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54
[MongoDB.url]:https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white
[Knime.url]:https://img.shields.io/badge/knime-FFA500?style=for-the-badge&logo=knime&logoColor=white
[Azure.url]:https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white

