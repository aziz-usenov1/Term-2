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
    <li>
      <a href="#bls-api-wage-analysis">BLS API Wage Analysis: State-Level Hourly Wage Comparison</a>
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

### BLS API Wage Analysis
This project utilizes the Bureau of Labor Statistics (BLS) API to fetch hourly wage data for 2023 across U.S. states. The analysis compares this data with average hourly wages from LinkedIn, providing insights into discrepancies and trends between federal economic data and a professional job platform.

**Process**

- **Data Sources**
  - **BLS API:** Provides official hourly wage data for all U.S. states.
  - **LinkedIn Data:** Contains average hourly salary information by state for professional roles.
- **Steps in the Analysis**
  - **API Integration:**
    - Queried the BLS API for 2023 hourly wage data using state-specific series IDs.
    - Extracted and organized the data into a Pandas DataFrame.
  - **Data Preparation:** 
    - Mapped state names between the LinkedIn and BLS datasets to ensure consistency.
    - Processed the LinkedIn dataset to calculate state-level average hourly wages.
  - **Comparison:** 
    - Merged BLS and LinkedIn datasets on state names.
    - Calculated absolute `(Difference (Units))` and percentage `(Difference (%))` differences in wages.
  - **Validation:** 
    - Identified and excluded outliers (e.g., salaries above $500/hour) to maintain accurate analysis.
    - Formatted data for readability.

**Results**

*State-Level Comparison*
The BLS API data reveals notable differences compared to LinkedIn hourly wages:
  - Key States with Large Differences
    - Alaska: LinkedIn wages are 63.86% higher than BLS.
    - Iowa: LinkedIn wages are 63.15% higher than BLS.
    - District of Columbia: BLS wages slightly exceed LinkedIn (-2.29%).
   
*National Average*
- **LinkedIn Average Hourly Salary:** $40.80
- **BLS Average Hourly Salary:** $32.75
- **Difference (Units):** $8.05
- **Difference (%):** 24.58%

*Interpretation of Results*
- **BLS API Data vs LinkedIn:**
    - LinkedIn data shows consistently higher wages due to its focus on professional and specialized roles.
    - BLS data, representing all industries and roles, provides a broader but lower average.
- **Regional Trends:**
    - States with high LinkedIn premiums (e.g., Alaska, Iowa) highlight demand for professionals in certain regions.
    - Discrepancies vary widely by state, influenced by local economies and job markets.
- **Data Limitations:**
    - Scope Differences: BLS captures a broad workforce; LinkedIn focuses on higher-paying jobs.
    - Data Cleaning: Outliers were removed to maintain data integrity.

**Conclusion**

This project demonstrates the integration of the BLS API for wage analysis and highlights its value in comparing data across different platforms. The observed wage differences underscore the importance of contextualizing salary data based on the source.



<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- MARKDOWN LINKS & IMAGES -->

[MySQL.url]: https://img.shields.io/badge/mysql-4479A1.svg?style=for-the-badge&logo=mysql&logoColor=white
[Python.url]:https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54
[MongoDB.url]:https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white
[Knime.url]:https://img.shields.io/badge/knime-FFA500?style=for-the-badge&logo=knime&logoColor=white
[Azure.url]:https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white

