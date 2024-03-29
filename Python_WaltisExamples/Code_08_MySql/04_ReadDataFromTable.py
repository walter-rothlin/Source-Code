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

db_schema_name = 'geno_test'

if db_schema_name == 'sakila':
    db_schema = mysql_db_connect(db_host='localhost',
                     db_schema='sakila',
                     db_user_name='root',
                     password='admin',
                     trace=False)

elif db_schema_name == 'geno_test':
    db_schema = mysql_db_connect(db_host='localhost',
                     db_schema='genossame_wangen',
                     db_user_name="App_User_Stammdaten",
                     password="1234ABCD12abcd",
                     trace=False)
    db_schema_name == 'genossame_wangen'

elif db_schema_name == 'geno_prod':
    db_schema = mysql_db_connect(db_host='192.168.253.24',
                     port=3311,
                     db_schema='genossame_wangen',
                     db_user_name="Web_App_User",
                     password="Geno_8855!",
                     trace=False)
    db_schema_name == 'genossame_wangen'


myCursor = db_schema.cursor()

data_tuples = get_table_records(db_schema, table_name='Personen', where_clause="ID=644", as_dictionary=True, take_action=True, verbal=False)
print(data_tuples)
print(create_sql_stmt_from_rs(data_tuples, table_name='Personen', as_csv=False, take_action=False, verbal=False))

halt()

tables_to_read = ['Land', 'Priviliges', 'Personen']
for a_table in tables_to_read:
    insert_str = create_sql_stmt_from_rs(
                    get_table_records(db_schema, table_name=a_table, as_dictionary=True, take_action=True, verbal=False),
                    table_name=a_table, as_csv=False, take_action=False, verbal=False)
    print(insert_str)




print('\n\n')
# etupl_types = get_db_attr_type_new(db_schema, schema_name='db_schema_name', table_name='language', take_action=True, verbal=True)
# print(tuple_types)
print('\n\n')
