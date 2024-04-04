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
# insert_str = create_insert_data_stmt(db_schema, table_name='Personen', where_clause="Ledig_Name='Rothlin'")
# print(insert_str)
# halt()

tables_to_read = ['# Properties',
                  'Land',
                  'Orte',
                  'Adressen',
                  'Personen',
                  'Priviliges',
                  'Personen_has_Priviliges',
                  'EMail_Adressen',
                  'Personen_has_EMail_Adressen',
                  'Telefonnummern',
                  'Personen_has_Telefonnummern',
                  'IBAN',
                  'Kommissionen_Gruppen',
                  'Gehört_zu_Kommissionen',
                  '# Entschädigungs_Modelle',
                  '# Durchleitungsrechte',
                  'Wärmeanschlüsse',
                  'Landteile']


insert_str = ''
for a_table in tables_to_read:
    if a_table.startswith('#'):
        print(f'WARNING: Table {a_table} not extracted!')
    else:
        print(f'INFO: Data extracted from {a_table}')
        insert_str = f'''
        {insert_str}
        
        {create_insert_data_stmt(db_schema, table_name=a_table)}
        '''

insert_str = f'''
SET FOREIGN_KEY_CHECKS = 0;

{insert_str}

SET FOREIGN_KEY_CHECKS = 1;
'''

File_create(r'C:\Users\Landwirtschaft\Documents\SoruceCode\Datenbanken\Scripts\Geno_Data_Extract.sql', insert_str)




print('\n\n')
# etupl_types = get_db_attr_type_new(db_schema, schema_name='db_schema_name', table_name='language', take_action=True, verbal=True)
# print(tuple_types)
print('\n\n')
