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
      <a href="#azure-setup">Data Setup on the cloud: Azure</a>
    </li>
    <li>
      <a href="#local-database-mysql">Local Database Setup MySQL Workbench</a>
    </li>
    <li>
      <a href="#knime">Knime Workflow</a>
    </li>
    <li>
      <a href="#hypothesis-analysis">Hypothesis Analysis</a>
    </li>
    <li>
      <a href="#summary">Summary</a>
    </li>
  </ol>
</details>

### About The Project
The project provides a comprehensive analysis of jobs advertised on LinkedIn through a multi-platform data aggregation methodology to draw meaningful insights. The dataset is retrived from [Kaggle](https://www.kaggle.com/datasets/arshkon/linkedin-job-postings/data), and is undergone advanced data processing and analytical workflows. 

It has uploaded its main dataset into Azure to support scalable cloud-based solutions. In addition, a minor portion of the data is being stored in MongoDB for text analysis and exploration purposes. Because Azure services are quite costly, establishing a local MySQL database with MySQL Workbench is cost-efficient in terms of data storage and queries.

As a means of widening the scope of analysis, the project pulls in Bureau of Labor Statistics [(BLS)](https://www.bls.gov/help/hlpforma.htm#C) data using API. This would allow one to drill down into the comparison of official wage data to those of actual company offers appearing on LinkedIn, resulting in profound analysis with trustworthy outside references. 

This KNIME Workflow also covers all the ETL processes of all these data sources. This workflow becomes the central place for integrating, transforming, and presenting the data, as it showcases the whole pipeline for data. 

There is detailed documentation on the KNIME Workflow under the KNIME section, demonstrating the whole ETL process and the analysis results achieved for the project.

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

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- MARKDOWN LINKS & IMAGES -->

[MySQL.url]: https://img.shields.io/badge/mysql-4479A1.svg?style=for-the-badge&logo=mysql&logoColor=white
[Python.url]:https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54
[MongoDB.url]:https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white
[Knime.url]:https://img.shields.io/badge/knime-FFA500?style=for-the-badge&logo=knime&logoColor=white
[Azure.url]:https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white

