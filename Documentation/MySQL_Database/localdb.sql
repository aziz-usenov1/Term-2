drop schema if exists linkedin_jobs;
Create schema linkedin_jobs;
USE linkedin_jobs;

-- Table for companies
CREATE TABLE companies (
    company_id BIGINT,
    name VARCHAR(255),
    description VARCHAR(5000),
    company_size VARCHAR(255),
    state VARCHAR(255),
    country VARCHAR(255),
    city VARCHAR(255),
    zip_code VARCHAR(100),
    address VARCHAR(255),
    url VARCHAR(255)
);

-- Table for company industries
CREATE TABLE company_industries (
    company_id INT,
    industry VARCHAR(5000)
);

-- Table for company specialities
CREATE TABLE company_specialities (
    company_id INT,
    speciality VARCHAR(3000)
);

-- Table for employee counts
CREATE TABLE employee_counts (
    company_id INT,
    employee_count INT,
    follower_count INT,
    time_recorded INT
);

-- Table for benefits
CREATE TABLE benefits (
    job_id BIGINT,
    inferred BIGINT,
    type VARCHAR(50)
);

-- Table for job industries
CREATE TABLE job_industries (
    job_id BIGINT,
    industry_id SMALLINT
);

-- Table for job skills
CREATE TABLE job_skills (
    job_id BIGINT,
    skill_abr VARCHAR(50)
);

-- Table for salaries
CREATE TABLE salaries (
    salary_id BIGINT,
    job_id BIGINT,
    max_salary VARCHAR(255),
    med_salary VARCHAR(255),
    min_salary VARCHAR(255),
    pay_period VARCHAR(50),
    currency VARCHAR(50),
    compensation_type VARCHAR(50)
);

-- Table for industries
CREATE TABLE industries (
    industry_id BIGINT,
    industry_name VARCHAR(100)
);

-- Table for skills
CREATE TABLE skills (
    skill_abr VARCHAR(50),
    skill_name VARCHAR(50)
);

-- Table for job postings
CREATE TABLE postings (
    job_id BIGINT,
    company_name VARCHAR(255),
    title VARCHAR(255),
    description VARCHAR(3000),
    max_salary FLOAT,
    pay_period VARCHAR(50),
    location VARCHAR(255),
    company_id BIGINT,
    views FLOAT,
    med_salary FLOAT,
    min_salary FLOAT,
    formatted_work_type VARCHAR(255),
    applies FLOAT,
    original_listed_time FLOAT,
    remote_allowed FLOAT,
    job_posting_url VARCHAR(255),
    application_url VARCHAR(255),
    application_type VARCHAR(255),
    expiry FLOAT,
    closed_time FLOAT,
    formatted_experience_level VARCHAR(255),
    skills_desc VARCHAR(255),
    listed_time FLOAT,
    posting_domain VARCHAR(255),
    sponsored TINYINT(1),
    work_type VARCHAR(255),
    currency VARCHAR(50),
    compensation_type VARCHAR(50),
    normalized_salary FLOAT,
    zip_code VARCHAR(100),
    fips FLOAT
);

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
  
  
LOAD DATA INFILE '/private/tmp/company_industries.csv'
INTO TABLE company_industries
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@company_id, @industry)
SET
  company_id = @company_id,
  industry = LEFT(NULLIF(@industry, ''), 3000);

LOAD DATA INFILE '/private/tmp/company_specialities.csv'
INTO TABLE company_specialities
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@company_id, @speciality)
SET
  company_id = @company_id,
  speciality = LEFT(NULLIF(@speciality, ''), 3000);

LOAD DATA INFILE '/private/tmp/employee_counts.csv'
INTO TABLE employee_counts
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@company_id, @employee_count, @follower_count, @time_recorded)
SET
  company_id = @company_id,
  employee_count = @employee_count,
  follower_count = @follower_count,
  time_recorded = @time_recorded;
  
  
  
LOAD DATA INFILE '/private/tmp/benefits.csv'
INTO TABLE benefits
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@job_id, @inferred, @type)
SET
  job_id = @job_id,
  inferred = @inferred,
  type = LEFT(NULLIF(@type, ''), 50);
  
LOAD DATA INFILE '/private/tmp/job_industries.csv'
INTO TABLE job_industries
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@job_id, @industry_id)
SET
  job_id = @job_id,
  industry_id = @industry_id;
  
LOAD DATA INFILE '/private/tmp/job_skills.csv'
INTO TABLE job_skills
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@job_id, @skill_abr)
SET
  job_id = @job_id,
  skill_abr = LEFT(NULLIF(@skill_abr, ''), 50);
  
LOAD DATA INFILE '/private/tmp/salaries.csv'
INTO TABLE salaries
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@salary_id, @job_id, @max_salary, @med_salary, @min_salary, @pay_period, @currency, @compensation_type)
SET
  salary_id = @salary_id,
  job_id = @job_id,
  max_salary = NULLIF(@max_salary, ''),
  med_salary = NULLIF(@med_salary, ''),
  min_salary = NULLIF(@min_salary, ''),
  pay_period = LEFT(NULLIF(@pay_period, ''), 50),
  currency = LEFT(NULLIF(@currency, ''), 50),
  compensation_type = LEFT(NULLIF(@compensation_type, ''), 50);


LOAD DATA INFILE '/private/tmp/industries.csv'
INTO TABLE industries
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@industry_id, @industry_name)
SET
  industry_id = @industry_id,
  industry_name = LEFT(NULLIF(@industry_name, ''), 100);
  

LOAD DATA INFILE '/private/tmp/skills.csv'
INTO TABLE skills
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@skill_abr, @skill_name)
SET
  skill_abr = LEFT(NULLIF(@skill_abr, ''), 50),
  skill_name = LEFT(NULLIF(@skill_name, ''), 50);
  
LOAD DATA INFILE '/private/tmp/postings.csv'
INTO TABLE postings
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@job_id, @company_name, @title, @description, @max_salary, @pay_period, @location, @company_id, @views, @med_salary, @min_salary, 
 @formatted_work_type, @applies, @original_listed_time, @remote_allowed, @job_posting_url, @application_url, @application_type, 
 @expiry, @closed_time, @formatted_experience_level, @skills_desc, @listed_time, @posting_domain, @sponsored, @work_type, 
 @currency, @compensation_type, @normalized_salary, @zip_code, @fips)
SET
  job_id = @job_id,
  company_name = LEFT(NULLIF(@company_name, ''), 255),
  title = LEFT(NULLIF(@title, ''), 255),
  description = LEFT(NULLIF(@description, ''), 2999),
  max_salary = @max_salary,
  pay_period = LEFT(NULLIF(@pay_period, ''), 50),
  location = LEFT(NULLIF(@location, ''), 255),
  company_id = @company_id,
  views = @views,
  med_salary = @med_salary,
  min_salary = @min_salary,
  formatted_work_type = LEFT(NULLIF(@formatted_work_type, ''), 255),
  applies = @applies,
  original_listed_time = @original_listed_time,
  remote_allowed = @remote_allowed,
  job_posting_url = LEFT(NULLIF(@job_posting_url, ''), 255),
  application_url = LEFT(NULLIF(@application_url, ''), 255),
  application_type = LEFT(NULLIF(@application_type, ''), 255),
  expiry = @expiry,
  closed_time = @closed_time,
  formatted_experience_level = LEFT(NULLIF(@formatted_experience_level, ''), 255),
  skills_desc = LEFT(NULLIF(@skills_desc, ''), 255),
  listed_time = @listed_time,
  posting_domain = LEFT(NULLIF(@posting_domain, ''), 255),
  sponsored = @sponsored,
  work_type = LEFT(NULLIF(@work_type, ''), 255),
  currency = LEFT(NULLIF(@currency, ''), 50),
  compensation_type = LEFT(NULLIF(@compensation_type, ''), 50),
  normalized_salary = @normalized_salary,
  zip_code = LEFT(NULLIF(@zip_code, ''), 100),
  fips = @fips;


  select * from companies limit 100;
  
  -- SHOW VARIABLES LIKE "local_infile";
