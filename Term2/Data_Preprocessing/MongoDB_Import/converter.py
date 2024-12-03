# Converter: CSV -> JSON

import json
import csv
import pandas as pd

#================================================================#
# Converting Companies.csv to Json file

with open('companies.csv', 'r') as f:
    reader = csv.reader(f)
    next(reader)
    data = []
    for row in reader:
        data.append(
            {'company_id': row[0],
             'description': row[2]})

with open('companies.json', 'w') as f:
    json.dump(data, f, indent=4)
 
#================================================================#
# Dropping all NA values in 'skills_desc' column
 
posts = pd.read_csv('postings.csv')
posts['skills_desc'].isna().sum()
posts.dropna(subset=['skills_desc'], inplace=True)
posts.to_csv('skills.csv') 

# Converting skills description from Postings.csv to Json file

with open('skills.csv', 'r') as f:
    reader = csv.reader(f)
    next(reader)
    data = []
    for row in reader:
        data.append(
            {'job_id': row[1],
             'skills_desc': row[22]})

with open('skills.json', 'w') as f:
    json.dump(data, f, indent=4)

#================================================================#
# Converting posting job description from Postings.csv to Json file

with open('postings.csv', 'r') as f:
    reader = csv.reader(f)
    next(reader)
    data = []
    for row in reader:
        data.append(
            {'job_id': row[0],
             'description': row[3]})

with open('post_description.json', 'w') as f:
    json.dump(data, f, indent=4)
