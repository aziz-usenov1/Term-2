<a id="readme-top"></a>

<div align="center">
  
# Term-2
**Contributors:**
Azizbek Ussenov, Guillermo Leal, Tatyana Yakushina, Yutong Liang
## Linkedin Job Postings Analysis
<img src="https://github.com/user-attachments/assets/94c30a65-0172-461f-b422-728b1e724fa2" alt="Linkedin" width="600" height="350" align="center">

Source: [Finlink](https://www.google.com/url?sa=i&url=https%3A%2F%2Ffinlink.co.uk%2Felevate-your-linkedin-profile-a-guide-before-partnering-with-finlink%2F&psig=AOvVaw2FXq4NK-e_Lmqt5hR4GEYk&ust=1733347094544000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCLCPtLzDjIoDFQAAAAAdAAAAABAE)

<details open>
  <summary>Table of Contents</summary>
  <div align="center">
    <p></p><a href="#about-the-project">About The Project</a></p>
    <p></p><a href="#data-setup-on-the-cloud-azure-and-mysql-workbench">Data Setup on the cloud (Azure) and MySQL Workbench</a></p>
    <p></p><a href="#mongodb-data-integration-workflow">MongoDB Data Integration Workflow</a></p>
    <p></p><a href="#bls-api-wage-analysis">BLS API Wage Analysis</a></p>
    <p></p><a href="#knime-workflow">Knime Workflow</a></p>
    <p></p><a href="#summary">Summary</a></p>
  </div>
</details>
</div>

<hr> 

## About The Project


The project provides a comprehensive analysis of jobs advertised on LinkedIn through a multi-platform data aggregation methodology to draw meaningful insights. The dataset is retrived from [Kaggle](https://www.kaggle.com/datasets/arshkon/linkedin-job-postings/data), and is undergone advanced data processing and analytical workflows. 

The dataset has been uploaded into Azure to support scalable cloud-based solutions. In addition, a minor portion of the data is being stored in MongoDB for text analysis and exploration purposes. Because Azure services are quite costly, a cost-efficient local database has been established with MySQL Workbench for storage and queries.

As a means of widening the scope of analysis, the project pulls in Bureau of Labor Statistics [(BLS)](https://www.bls.gov/help/hlpforma.htm#C) data using API. This would allow one to drill down into the comparison of official wage data to those of actual company offers appearing on LinkedIn, resulting in deep analysis with reliable outside references. 

The KNIME Workflow is used throughout the process and it covers all the ETL processes of all these data sources being integrated, transformed, and presented the data, as it showcases the whole pipeline for data. The detailed documentation can be found on the KNIME section.

**We will test four hypotheses throughout the analysis process and present the outputs using the KNIME workflow and charts:**
- Senior roles are less likely to offer remote work options compared to entry- and mid-level positions.
- SQL is more frequently required in IT and data-centric industries such as finance, healthcare, and e-commerce compared to other sectors.
- LinkedIn wages are consistently higher than BLS wages across all U.S. states due to a focus on professional roles.
- LinkedIn-reported wages are consistently higher than BLS wages across key industries due to LinkedIn's focus on specialized, professional, and high-demand roles, compared to the broader coverage of the BLS data.

## Built With

* ![Python][Python.url]
* ![MongoDB][MongoDB.url]
* ![Azure][Azure.url]
* ![MySQLWorkbench][MySQL.url]
* ![Knime][Knime.url]

<p align="right">(<a href="#readme-top"> 🔝 back to top</a>)</p>

<hr>

## Data Setup on the cloud (Azure) and MySQL Workbench 
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

#### 🔸 Stage 1: Setup Local MySQL Database
#### 🔴 SQL workfile for creating Local Database: [MySQL Workbench](localdb.sql)
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
#### ERR Diagram
![EER Diagram](https://github.com/user-attachments/assets/6dff872d-b08c-4570-9a18-fce6ef1693a1)

#### 🔸 Stage 2: Transition to Azure SQL Database

##### Step 2.1: Configure Azure SQL Database
1. **Create Azure SQL Database**:
   - Log in to the [Azure Portal](https://portal.azure.com/).
   - Navigate to **SQL Databases > Create**.
   - Use the **Free Tier (vCore-based)** for student accounts:
     - Set up a resource group.
     - Select a logical server name, `LinkedIn_Jobs`.
   - Set up admin login credentials.
2. Save connection details (server name, admin username, and password).

##### Step 2.2: Install Azure Data Studio
1. Download and install Azure Data Studio from the [official website](https://learn.microsoft.com/en-us/sql/azure-data-studio/).
2. Set up a connection to your Azure SQL Database:
   - Server: `{your_server_name}.database.windows.net`
   - Authentication: SQL Login
   - Username: `{admin_username}`
   - Password: `{admin_password}`
![azure-server](https://github.com/user-attachments/assets/386eb159-1d53-41af-9298-81595b52d908)

##### Step 2.3: Import CSV Files into Azure
1. Use Azure Data Studio's Import Wizard:
   - Right-click on the database and select **Import Wizard**.
   - Upload each CSV file one at a time.
   - Map columns to appropriate data types during the import process.
2. Verify each table and column using SQL queries:
   ```sql
   SELECT TOP (10) * FROM dbo.job_postings;
   ```
![azure-db](https://github.com/user-attachments/assets/f9c89fbf-c464-4ad8-b7ef-e944132d7122)

##### Step 2.4: Optimize Resource Usage
1. Clear working sessions to allow **auto-pause**
    - Free-tire does not offer configured auto-pause settion. One must disconnect all the working sessions to make sure can server meets the standard of auto-pausing to save free-tire resources.
2. Monitor resource usage:
   - Use the **Performance Overview** in Azure Portal.
   - Check DTU/vCore consumption periodically.

#### 🔸 Step 3: Connection to KNIME

This section details the process of connecting both the local MySQL database and Azure SQL Database to KNIME Analytics Platform. These steps include downloading drivers, setting up configurations, and performing test queries.

#### **Step 3.1: Connecting KNIME to Local MySQL Database**

##### **Download MySQL JDBC Driver**
1. Download the MySQL Connector/J (JDBC driver) from the [official MySQL website](https://dev.mysql.com/downloads/connector/j/).
   - Select the appropriate version for your system and download the `.zip` file.
2. Extract the `.jar` file (e.g., `mysql-connector-java-8.x.x.jar`) from the downloaded archive.
3. Place the `.jar` file in a known directory for future reference.
   
![driver](https://github.com/user-attachments/assets/8d21901d-c09b-43c7-b616-eab57aa62411)

##### **Configure KNIME Database Driver**
1. Open KNIME Analytics Platform.
2. Navigate to **File > Preferences > KNIME > Databases**.
3. Add a new database driver:
   - Click **Add File...** and browse to the `.jar` file downloaded earlier.
   - Assign an alias, e.g., `MySQL Driver`.

##### **Set Up MySQL Connection Node**
1. Drag and drop the **Database Connector** node from the KNIME Node Repository onto the workflow canvas.
2. Configure the node:
   - **Driver**: Select `MySQL Driver` from the dropdown.
   - **Database URL**: `jdbc:mysql://localhost:3306/linkedin_jobs`
     - Replace `linkedin_jobs` with your database name if different.
   - **Authentication**:
     - **Username**: Enter the MySQL username (default: `root` or your custom user).
     - **Password**: Enter the MySQL password.
3. Click **OK** to save.

##### **Test the Connection**
1. Connect a **Database Table Selector** node to the **Database Connector**.
2. Open the configuration of the **Table Selector** node and type a query, e.g.:
   ```sql
   SELECT * FROM job_postings LIMIT 10;
    ```

#### **Step 3.2: Connecting KNIME to Azure SQL Database**

##### **Download Microsoft SQL JDBC Driver**
1. Download the SQL Server JDBC driver from the [Microsoft website](https://learn.microsoft.com/en-us/sql/connect/jdbc/download-microsoft-jdbc-driver-for-sql-server).
   - Choose the appropriate `.zip` file for your platform.
2. Extract the `.jar` file (e.g., `mssql-jdbc-9.x.x.jre8.jar`) from the archive.
3. Save the `.jar` file to a known directory.

##### **Configure KNIME Database Driver**
1. Open KNIME Analytics Platform.
2. Navigate to **File > Preferences > KNIME > Databases**.
3. Add a new database driver:
   - Click **Add File...** and locate the `.jar` file downloaded earlier.
   - Assign an alias, e.g., `SQL Server Driver`.

##### **Set Up Azure SQL Connection Node**
1. Drag and drop the **Database Connector** node from the KNIME Node Repository onto the workflow canvas.
2. Configure the node:
   - **Driver**: Select `SQL Server Driver` from the dropdown.
   - **Database URL**: 
     ```plaintext
     jdbc:sqlserver://job-posting-2024.database.windows.net:1433;database=LinkedIn_Jobs
     ```
     - Replace `job-posting-2024` with your Azure SQL Server name.
     - Replace `LinkedIn_Jobs` with your database name.
   - **Authentication**:
     - **Username**: Enter your Azure SQL admin username.
     - **Password**: Enter your Azure SQL admin password.
   - **Dialect**: Use `SQL-92` (default for this driver).
![sample-output](https://github.com/user-attachments/assets/d63abb62-8919-4cf7-a1de-e021fa3a175e)

<p align="right">(<a href="#readme-top">🔝 back to top</a>)</p>

<hr>

## MongoDB Data Integration Workflow
This section showcases the workflow for transforming, splitting, and integrating large datasets into a MongoDB database. 

**The main tasks include:**
- **CSV to JSON Conversion:** [converter.py](Data_Preprocessing/MongoDB_Import/converter.py) 
  - Extracting relevant columns from a respective file
  - Converting the data into a JSON format suitable for MongoDB
- **JSON Chunking:** [chunking_and_mongodb_importing.py](Data_Preprocessing/MongoDB_Import/chunking_and_mongodb_importing.py)
  - Splitting the JSON file into *`N`* smaller chunks to adhere to MongoDB's 16MB document size limit
- **Data Import to MongoDB:** [chunking_and_mongodb_importing.py](Data_Preprocessing/MongoDB_Import/chunking_and_mongodb_importing.py)
  - Importing the data into MongoDB through `from pymongo import MongoClient` library
    - need `connection string` labeled as `client`
    - need `password` within `connectin string`
    - need `database name` labeled as `db`
    - need `folder name` labeled as `collection`
- **MongoDB Database Structure**:
  - The created database is called **`linkedin_companies`** and it has 3 collections (*please see the snapshot below*):
    - `companies`
    - `post_description`
    - `skills`
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

**The Snapshot of MongoDB Cluster**
![](https://github.com/user-attachments/assets/93b0fc65-caa3-4aec-9374-97b379888e7e)
<hr>

## BLS API Wage Analysis
This project utilizes the Bureau of Labor Statistics (BLS) API to fetch hourly wage data for 2023 across U.S. states. The analysis compares this data with average hourly wages from LinkedIn, providing insights into discrepancies and trends between federal economic data and a professional job platform.

**Process**

- **Data Sources**
  - **BLS API:** Provides official hourly wage data for all U.S. states and industries. Link to requst API can be found [here](https://data.bls.gov/registrationEngine/)
  - **LinkedIn Data:** Contains average hourly salary information by state and industry.
- **Steps in the Analysis**
  - **API Integration:**
    - Queried the BLS API for 2023 hourly wage data using state-specific and industry-specific series IDs.
    - Extracted and organized the data into a Pandas DataFrame.
  - **Data Preparation:** 
    - Mapped state names between the LinkedIn and BLS datasets to ensure consistency.
    - Mapped clustered industry names between LinkedIn and BLS datasets for better consistency.
    - Processed the LinkedIn dataset to calculate state-level and industry-level average hourly wages.

<p align="right">(<a href="#readme-top"> 🔝 back to top</a>)</p>

<hr>

## Knime Workflow
❗️**The comprehensive view of Knime Workflow with necessary `nodes` to execute and info about each block in the workflow is provided below:**

![knime](https://github.com/user-attachments/assets/9c19e588-d640-4183-b75b-ae47ff376157)

## Hypothesis Analysis

🔸 **We provide the analysis and outputs of the 4 hypotheses we aimed to test through this KNIME workflow. It demonstrates an ETL procedure for all hypotheses to analyze and draw meaningful insights about job trends.**

We state the following *<ins>4 hypotheses</ins>*:

**Hypothesis 1**. Senior roles are less likely to offer remote work options compared to entry- and mid-level positions.

![hypothesis1](https://github.com/user-attachments/assets/179e8305-8f45-41d2-9941-7f0da66565ba)



_Conclusion_: Based on the pie chart, senior-level roles are the least likely to offer remote work options, supporting the hypothesis that senior roles are less likely to provide remote work opportunities compared to entry- and mid-level positions.

**Hypothesis 2**. SQL is more frequently required in IT and data-centric industries such as finance, healthcare, and e-commerce compared to other sectors.

![hypothesis2](https://github.com/user-attachments/assets/92500dee-45a4-401d-a2e9-a75657354a90)



_Conclusion_: The bubble chart shows that SQL is highly demanded in industries like IT Services and Software Development, with significant representation in data-centric sectors such as Financial Services and Healthcare. Thus, it supports the stated hypothesis.

**Hypothesis 3**. LinkedIn wages are consistently higher than BLS wages across all U.S. states due to a focus on professional roles.

![hypothesis3](https://github.com/user-attachments/assets/f475789b-e48d-4e7a-a493-af651d49597e)


_Conclusion_: The analysis demonstrates that LinkedIn consistently reports higher average hourly wages compared to the BLS across most U.S. states. On a national level, LinkedIn wages are 24.58% higher than BLS wages, further supporting the idea that LinkedIn caters to higher-paying industries and job markets.

**Hypothesis 4**. LinkedIn-reported wages are consistently higher than BLS wages across key industries due to LinkedIn's focus on specialized, professional, and high-demand roles, compared to the broader coverage of the BLS data.

❗️**Clusterings were applied to get common category names for both Linkedin dataset and API extracted data. In total, 25 category names were generated for analysis purposes even though the Silhouette Score showed the optimal number of clusters is 221. The processing can be found here: [industry_names.py](Data_Preprocessing/API_Analysis/industry_Clustering.ipynb)**

![hypothesis3](https://github.com/user-attachments/assets/522c41ef-1549-4a2d-be9e-d19667aa5e8a)

_Conclusion_: The table reveals that LinkedIn consistently reports higher average hourly wages compared to the BLS across the selected industries. This supports the hypothesis that LinkedIn data focuses on specialized and professional roles, which command higher wages. Industries such as Professional and Business Services and General Manufacturing show significant differences, indicating a disparity between LinkedIn's professional-oriented dataset and the broader scope of the BLS. These findings emphasize the importance of considering data sources' scope when analyzing wage trends.

<p align="right">(<a href="#readme-top">🔝 back to top</a>)</p>



<hr>

## Summary

In general, this project succeeded in working with Azure, MongoDB, a local MySQL database, API data extraction, and KNIME, along with preprocessing techniques - *data cleaning and algorithms of cosine similarity and clustering of industry names for creating common categories both for LinkedIn and API-based data* - in all hypotheses proved right according to the analysis.

<!-- MARKDOWN LINKS & IMAGES -->

<p align="right">(<a href="#readme-top">🔝 back to top</a>)</p>

[MySQL.url]: https://img.shields.io/badge/mysql-4479A1.svg?style=for-the-badge&logo=mysql&logoColor=white
[Python.url]:https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54
[MongoDB.url]:https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white
[Knime.url]:https://img.shields.io/badge/knime-FFA500?style=for-the-badge&logo=knime&logoColor=white
[Azure.url]:https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white

