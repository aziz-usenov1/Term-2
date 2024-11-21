### Database Setup - On the Cloud

This README provides a comprehensive guide on how we processed relational data from Kaggle’s LinkedIn Job Postings dataset across two stages:  
1. Using a local MySQL database for initial work and analysis for the purpose of cost saving.  
2. Migrating to an Azure SQL Database for collaborative work and delivery.


### Prerequisites

#### Tools and Resources
- **Azure SQL Database Free Tier** (registered via a Student Account).
- **Azure Data Studio** (for data import and schema modifications).
- **MySQLWorkbench** (for setting up a local database).
- **KNIME Analytics Platform** (for connecting and utilizing the database).
- **Kaggle Dataset**: [LinkedIn Job Postings](https://www.kaggle.com/datasets/arshkon/linkedin-job-postings).
    
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
#### Step 3: Connection to KNIME

This section details the process of connecting both the local MySQL database and Azure SQL Database to KNIME Analytics Platform. These steps include downloading drivers, setting up configurations, and performing test queries.

---

#### **Step 3.1: Connecting KNIME to Local MySQL Database**

##### **Download MySQL JDBC Driver**
1. Download the MySQL Connector/J (JDBC driver) from the [official MySQL website](https://dev.mysql.com/downloads/connector/j/).
   - Select the appropriate version for your system and download the `.zip` file.
2. Extract the `.jar` file (e.g., `mysql-connector-java-8.x.x.jar`) from the downloaded archive.
3. Place the `.jar` file in a known directory for future reference.

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

Step 3.2: Connecting KNIME to Azure SQL Database

### **Download Microsoft SQL JDBC Driver**
1. Download the SQL Server JDBC driver from the [Microsoft website](https://learn.microsoft.com/en-us/sql/connect/jdbc/download-microsoft-jdbc-driver-for-sql-server).
   - Choose the appropriate `.zip` file for your platform.
2. Extract the `.jar` file (e.g., `mssql-jdbc-9.x.x.jre8.jar`) from the archive.
3. Save the `.jar` file to a known directory.

### **Configure KNIME Database Driver**
1. Open KNIME Analytics Platform.
2. Navigate to **File > Preferences > KNIME > Databases**.
3. Add a new database driver:
   - Click **Add File...** and locate the `.jar` file downloaded earlier.
   - Assign an alias, e.g., `SQL Server Driver`.

#### **Set Up Azure SQL Connection Node**
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

