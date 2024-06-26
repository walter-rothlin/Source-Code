# ------------------------------------------------------------------
# Name: 03_DB_Access.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_BZU/2024/TI23_BLeM/03_DB_Access.py
#
# Description: Connects to DB-Schema and queries data
#
# Autor: Walter Rothlin
#
# History:
# 13-Jun-2024   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
#
from waltisLibrary import *
import mysql.connector # mysql-connector-python not default mässiger one

print('Connecting to sakila...', end='', )
db_connection = mysql.connector.connect(
    host='localhost',
    user='TI23_A', # root',
    password='TI23_A', # 'admin',
    database="sakila",
    auth_plugin='mysql_native_password'
)
print('....connected!')
search_pattern = input('Suchen nach:')
case_sensitive = input('Case-Sensitive (Y/N):').upper() == 'Y'

print(case_sensitive)
if search_pattern is None or search_pattern == '':
    where_clause = ''
else:

    if case_sensitive:
        where_clause = f"WHERE `city` LIKE BINARY '{search_pattern}'"
    else:
        where_clause = f"WHERE `city` LIKE '{search_pattern}'"

sql_statement = f"""
SELECT
    `c`.`city_id`      AS `ID`,
    `c`.`city`         AS `City_Name`,
    `c`.`country_id`   AS `Country_ID`,
    `c`.`last_update`  AS `Last_Update`
FROM `city` AS `c`
{where_clause};
"""


print(sql_statement)


my_cursor = db_connection.cursor(dictionary=True)
my_cursor.execute(sql_statement)
my_resultset = my_cursor.fetchall()
print(len(my_resultset))
# print(len(my_resultset), my_resultset)

# for a_tuple in my_resultset:
#     print(a_tuple['City_Name'])

