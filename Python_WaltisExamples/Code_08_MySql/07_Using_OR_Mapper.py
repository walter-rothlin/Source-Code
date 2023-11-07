#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 01_SelectSakila.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_08_MySql/01_SelectSakila.py
#
# Description: Connects to sakila and queries data
#
# Autor: Walter Rothlin
#
# History:
# 26-May-2020   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
#
from sqlalchemy import create_engine, MetaData, Table
from sqlalchemy.inspection import inspect

# Define your MySQL connection string
mysql_url = 'mysql://root:admin@localhost/bwi_a21'

# Create an engine to connect to the MySQL database
engine = create_engine(mysql_url)

# Create a metadata object
metadata = MetaData()

# Create an inspector object to inspect the database
inspector = inspect(engine)

# Get a list of table names in the database
table_names = inspector.get_table_names()

# Generate classes for each table
for table_name in table_names:
    print(table_name)
    # Reflect the table structure
    ### table = Table(table_name, metadata, autoload=True, autoload_with=engine)

    # Create a class name (you can customize this)
    ### class_name = table_name.capitalize()  # You can adjust this to match your naming convention

    # Create a Python class for the table
    ### new_class = type(class_name, (Base,), {'__table__': table})

    # Now, you can use the new_class to interact with the corresponding table
    # For example, you can query the table or perform other database operations

# Close the database connection
engine.dispose()
