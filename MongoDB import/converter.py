# Converter: CSV -> JSON

import json
import csv

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
    
