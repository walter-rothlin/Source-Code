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
import mysql.connector # mysql-connector-python not default mässiger one

print('Connecting to sakila...', end='', )
db_connection = mysql.connector.connect(
    host='localhost',
    user='root',
    password='admin',
    database="sakila",
    auth_plugin='mysql_native_password'
)
print('....connected!')

sql_statement = """
SELECT
	`c`.`city_id`      AS `ID`,
    `c`.`city`         AS `City_Name`,
    `c`.`country_id`   AS `Country_ID`,
    `c`.`last_update`  AS `Last_Update`
FROM `city` AS `c`
WHERE `city` LIKE 'O%';
"""

my_cursor = db_connection.cursor(dictionary=True)
my_cursor.execute(sql_statement)
my_resultset = my_cursor.fetchall()
print(len(my_resultset), my_resultset)

for a_tuple in my_resultset:
    print(a_tuple['City_Name'])

