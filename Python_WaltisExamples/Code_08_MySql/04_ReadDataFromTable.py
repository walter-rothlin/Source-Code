#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 04_ReadDataFromTable.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_08_MySql/04_ReadDataFromTable
#
# Description: Test-Program to read data (export) from a single table or a whole schema and stores it in
#              a csv- or sql-file
#
# Autor: Walter Rothlin
#
# History:
# 28-Mar-2024   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
from waltisLibrary import *

time_now = getTimestamp(formatString="{ts:%Y_%m_%d__%H%M%S}")

db_schema_name = 'sakila'

tables_to_read = ['Store',
                  'Film',
                  '# language'
                 ]

file_to_store = f'./Data/Data_Extract_{time_now}.sql'
file_to_store = f'./Data/Data_Extract.sql'


if db_schema_name == 'sakila':
    db_schema = mysql_db_connect(db_host='localhost',
                     db_schema='sakila',
                     db_user_name='root',
                     password='admin',
                     trace=False)

insert_str = ''
file_header = f'''
-- ----------------------------------------
-- Data Extract by: 04_ReadDataFromTable.py (using create_insert_data_stmt())
--    at: {getTimestamp()}
-- 
-- Source:
--    db-Schema: {db_schema_name}
--    Tables: {tables_to_read}
-- 
-- Saved in: {file_to_store}
--
-- ----------------------------------------
'''

for a_table in tables_to_read:
    if a_table.startswith('#'):
        print(f'WARNING: Table {a_table.replace("#", "").strip()} not extracted!')
    else:
        print(f'INFO: Data extracted from {a_table}')
        insert_str = f'''
{insert_str}

{create_insert_data_stmt(db_schema, table_name=a_table)}'''

insert_str = f'''{file_header}
SET FOREIGN_KEY_CHECKS = 0;
{insert_str}

SET FOREIGN_KEY_CHECKS = 1;
'''

File_create(file_to_store, insert_str)
print(f'\nData saved in {file_to_store}')
