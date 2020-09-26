#!/usr/bin/python3

import pandas as pd
emp_details = {'Employee': {'Dave': {'ID': '001',
                                     'Salary': 2000,
                                     'Designation':'Python Developer'},
                            'Ava': {'ID':'002',
                                    'Salary': 2300,
                                    'Designation': 'Java Developer'},
                            'Joe': {'ID': '003',
                                    'Salary': 1843,
                                    'Designation': 'Hadoop Developer'}}}
df = pd.DataFrame(emp_details['Employee'])
print(df)