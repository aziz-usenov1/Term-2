<a id="readme-top"></a>

# Term-2
Linkedin Job Postings

<details>
  <summary>Table of Contents</summary>
  <ol>
      <!--Please adjust accordingly by adding content link by adding <li></li> -->
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#mongodb-data-integration-workflow">MongoDB Data Integration Workflow</a>
    </li>
    <li>
      <a href="#data-setup-on-the-cloud-azure-and-mysql-workbench">Data Setup on the cloud (Azure) and MySQL Workbench</a>
    </li>
    <li>
      <a href="#knime-workflow">Knime Workflow</a>
    </li>
    <li>
      <a href="#summary">Summary</a>
    </li>
  </ol>
</details>

### About The Project
The project provides a comprehensive analysis of jobs advertised on LinkedIn through a multi-platform data aggregation methodology to draw meaningful insights. The dataset is retrived from [Kaggle](https://www.kaggle.com/datasets/arshkon/linkedin-job-postings/data), and is undergone advanced data processing and analytical workflows. 

The dataset has been uploaded into Azure to support scalable cloud-based solutions. In addition, a minor portion of the data is being stored in MongoDB for text analysis and exploration purposes. Because Azure services are quite costly, a cost-efficient local database has been established with MySQL Workbench for storage and queries.

As a means of widening the scope of analysis, the project pulls in Bureau of Labor Statistics [(BLS)](https://www.bls.gov/help/hlpforma.htm#C) data using API. This would allow one to drill down into the comparison of official wage data to those of actual company offers appearing on LinkedIn, resulting in deep analysis with reliable outside references. 

This KNIME Workflow also covers all the ETL processes of all these data sources being integrated, transformed, and presented the data, as it showcases the whole pipeline for data. The detailed documentation can be found on the KNIME section.

### Built With

* ![Python][Python.url]
* ![MongoDB][MongoDB.url]
* ![Azure][Azure.url]
* ![MySQLWorkbench][MySQL.url]
* ![Knime][Knime.url]

<p align="right">(<a href="#readme-top"> 🔝 back to top</a>)</p>

### MongoDB Data Integration Workflow
This section showcases the workflow for transforming, splitting, and integrating large datasets into a MongoDB database. 

**The main tasks include:**
- **CSV to JSON Conversion:** [converter.py](MongoDB%20import/converter.py) 
  - Extracting relevant columns from a respective file
  - Converting the data into a JSON format suitable for MongoDB
- **JSON Chunking:** [chunking_and_mongodb_importing.py](MongoDB%20import/chunking_and_mongodb_importing.py)
  - Splitting the JSON file into n smaller chunks to adhere to MongoDB's 16MB document size limit
- **Data Import to MongoDB:** [chunking_and_mongodb_importing.py](MongoDB%20import/chunking_and_mongodb_importing.py)
  - Importing the data into MongoDB through `from pymongo import MongoClient` library
    - need `connection string` labeled as `client`
    - need `password` within `connectin string`
    - need `database name` labeled as `db`
    - need `folder name` labeled as `collection`
- **JSON Schema:**
  - The schema ensures each JSON document adheres to the following structure:
    - **Root Type:** Array, containing objects.
    - **Object Properties:**
      - `company_id` (*string*): Unique identifier for each company.
      - `job_id` (*string*): Unique identifier for each job.
      - `description` from <ins>company</ins> (*string*): Textual description of the company.
      - `description` from <ins>posts</ins> (*string*): Textual description of the post.
      - `skills_desc` (*string*): Textual description of the skills.
    - **Required Fields:**
      - Each object in the array must include both `company_id`, `job_id`, `skills_desc`, `description` for company and `description`for post
     
<p align="right">(<a href="#readme-top">🔝 back to top</a>)</p>

### Data Setup on the cloud (Azure) and MySQL Workbench 
This README provides a comprehensive guide on how we processed relational data from Kaggle’s LinkedIn Job Postings dataset across two stages:  
1. Using a local MySQL database for initial work and analysis for the purpose of cost saving.  
2. Migrating to an Azure SQL Database for collaborative work and delivery.


### Prerequisites

#### Tools and Resources
- **Azure SQL Database Free Tier** (registered via a Student Account).
- **Azure Data Studio** (for data import and schema modifications).
- **MySQLWorkbench** (for setting up a local database).
- **Kaggle Dataset**
    
### Workflow Summary

#### Stage 1: Setup Local MySQL Database
1. Download and prepare dataset csv files.
2. Create and populate a MySQL database locally using MySQL Workbench.

#### Stage 2: Transition to Azure SQL Database
1. Import datasets into Azure SQL Database using Azure Data Studio.
2. Optimize Azure SQL resource usage:
   - Clear all the work sessions to allow  **auto-pause** for cost-efficiency.
   - Monitor resource consumption effectively.
3. Establish connection between KNIME and Azure SQL Database for collaborative work.
    
### Detailed Steps

#### Stage 1: Setup Local MySQL Database

##### Step 1.1: Download Dataset
- Go to the [LinkedIn Job Postings Dataset](https://www.kaggle.com/datasets/arshkon/linkedin-job-postings) on Kaggle.
- Download the dataset, which consists of 11 CSV files.
- Extract all files into `/private/tmp`. (#TODD add secure == ON == 1 .... later)

##### Step 1.2: Install and Configure MySQL Workbench
1. Open MySQLWorkbench and set up a local connection:
   - **Host**: `localhost`
   - **Port**: `3306`
   - **Username**: (default `root` or your chosen username)
   - **Password**: (set during MySQL installation)
3. Create a new database schema for the project:
   ```sql
   CREATE SCHEMA LinkedInJobs;
   ```

##### Step 1.3: Import CSV Files
1. In MySQL Workbench, navigate to **Server > Data Import**.
2. Select **Import from CSV file** and upload each CSV file into a corresponding table.
3. Data populating:
    - Create tables, example:
     ```sql 
     CREATE TABLE job_postings (
         job_id INT NOT NULL,
         title VARCHAR(255),
         location VARCHAR(255),
         company VARCHAR(255),
         date_posted DATE,
         PRIMARY KEY (job_id)
     );
     ```
    - Data ingestion, example:

    ``` sql
    LOAD DATA INFILE '/private/tmp/companies.csv'
    INTO TABLE companies
    FIELDS TERMINATED BY ','  
    ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES
    (@company_id, @name, @description, @company_size, @state, @country, @city, @zip_code, @address, @url)
    SET
    company_id = @company_id,
    name = LEFT(NULLIF(@name, ''), 255),
    description = LEFT(NULLIF(@description, ''), 2999),
    company_size = LEFT(NULLIF(@company_size, ''), 255),
    state = LEFT(NULLIF(@state, ''), 255),
    country = LEFT(NULLIF(@country, ''), 255),
    city = LEFT(NULLIF(@city, ''), 255),
    zip_code = LEFT(NULLIF(@zip_code, ''), 100),
    address = LEFT(NULLIF(@address, ''), 255),
    url = LEFT(NULLIF(@url, ''), 255);
    
    ```
     
##### Verify the data integrity by querying each table:
   ```sql
   SELECT * FROM job_postings LIMIT 10;
   ```
    
#### Stage 2: Transition to Azure SQL Database

##### Step 2.1: Configure Azure SQL Database
1. **Create Azure SQL Database**:
   - Log in to the [Azure Portal](https://portal.azure.com/).
   - Navigate to **SQL Databases > Create**.
   - Use the **Free Tier (vCore-based)** for student accounts:
     - Set up a resource group.
     - Select a logical server name, `LinkedIn_Jobs`.
   - Set up admin login credentials.
2. Save connection details (server name, admin username, and password).

#### Step 2.2: Install Azure Data Studio
1. Download and install Azure Data Studio from the [official website](https://learn.microsoft.com/en-us/sql/azure-data-studio/).
2. Set up a connection to your Azure SQL Database:
   - Server: `{your_server_name}.database.windows.net`
   - Authentication: SQL Login
   - Username: `{admin_username}`
   - Password: `{admin_password}`

#### Step 2.3: Import CSV Files into Azure
1. Use Azure Data Studio's Import Wizard:
   - Right-click on the database and select **Import Wizard**.
   - Upload each CSV file one at a time.
   - Map columns to appropriate data types during the import process.
2. Verify each table and column using SQL queries:
   ```sql
   SELECT TOP (10) * FROM dbo.job_postings;
   ```

#### Step 2.4: Optimize Resource Usage
1. Clear working sessions to allow **auto-pause**
    - Free-tire does not offer configured auto-pause settion. One must disconnect all the working sessions to make sure can server meets the standard of auto-pausing to save free-tire resources.
2. Monitor resource usage:
   - Use the **Performance Overview** in Azure Portal.
   - Check DTU/vCore consumption periodically.
  
<p align="right">(<a href="#readme-top">🔝 back to top</a>)</p>

### Knime Workflow

### Hypothesis Analysis

We state the following three hypotheses:

**Hypothesis 1**. Senior roles are less likely to offer remote work options compared to entry- and mid-level positions.

![hypothesis1](https://github.com/user-attachments/assets/4d0acc4b-7e76-473f-b5f8-a78e800f9795)

_Conclusion_: Based on the pie chart, senior-level roles are the least likely to offer remote work options, supporting the hypothesis that senior roles are less likely to provide remote work opportunities compared to entry- and mid-level positions.

**Hypothesis 2**. SQL is more frequently required in IT and data-centric industries such as finance, healthcare, and e-commerce compared to other sectors.

![hypothesis2](https://github.com/user-attachments/assets/f27fb5fb-ed89-4e60-8c80-5e7806f5ee96)

_Conclusion_: The bubble chart shows that SQL is highly demanded in industries like IT Services and Software Development, with significant representation in data-centric sectors such as Financial Services and Healthcare. Thus, it supports the stated hypothesis.

**Hypothesis 3**. LinkedIn wages are consistently higher than BLS wages across all U.S. states due to a focus on professional roles.

![hypothesis3](https://github.com/GuillermoLeal95/attachments/blob/afad0595a7c0dbe5f4b039d7db3c62710d3d1f7b/State%20LindekIn%20vs%20BLS.jpg)

_Conclusion_: The analysis demonstrates that LinkedIn consistently reports higher average hourly wages compared to the BLS across most U.S. states. This aligns with the hypothesis that LinkedIn focuses on professional and specialized roles, which typically offer higher wages. On a national level, LinkedIn wages are 24.58% higher than BLS wages, further supporting the idea that LinkedIn caters to higher-paying industries and job markets.

**Hypothesis 4**. LinkedIn-reported wages are consistently higher than BLS wages across key industries due to LinkedIn's focus on specialized, professional, and high-demand roles, compared to the broader coverage of the BLS data.

![hypothesis3](https://github.com/GuillermoLeal95/attachments/blob/afad0595a7c0dbe5f4b039d7db3c62710d3d1f7b/Industry%20LinkedIn%20vs%20BLS.jpg)

_Conclusion_: The analysis reveals that LinkedIn consistently reports higher average hourly wages compared to the BLS across the selected industries. This supports the hypothesis that LinkedIn data focuses on specialized and professional roles, which command higher wages. Industries such as Professional and Business Services and General Manufacturing show significant differences, indicating a disparity between LinkedIn's professional-oriented dataset and the broader scope of the BLS. These findings emphasize the importance of considering data sources' scope when analyzing wage trends.

<p align="right">(<a href="#readme-top">🔝 back to top</a>)</p>

### Summary

<!-- MARKDOWN LINKS & IMAGES -->

<p align="right">(<a href="#readme-top">🔝 back to top</a>)</p>

[MySQL.url]: https://img.shields.io/badge/mysql-4479A1.svg?style=for-the-badge&logo=mysql&logoColor=white
[Python.url]:https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54
[MongoDB.url]:https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white
[Knime.url]:https://img.shields.io/badge/knime-FFA500?style=for-the-badge&logo=knime&logoColor=white
[Azure.url]:https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white

