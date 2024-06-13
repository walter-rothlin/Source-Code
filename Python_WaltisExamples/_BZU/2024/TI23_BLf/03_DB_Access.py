# ------------------------------------------------------------------
# Name: 03_DB_Access.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_BZU/2024/TI23_BLf/03_DB_Access.py
#
# Description: Connects to DB-Schema and queries data
#
# Autor: Walter Rothlin
#
# History:
# 13-Jun-2024   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
#

import mysql.connector # mysql-connector-python

print('Connecting to sakila...', end='', )
db_connection = mysql.connector.connect(
    host='localhost',
    user='Python_1',    # 'root',
    password='Python_1',    # 'admin',
    database="sakila",
    auth_plugin='mysql_native_password'
)
print('connected!')

do_loop = True
while do_loop:
    search_criteria = input('Suchmster (STOP):')
    if search_criteria == 'STOP':
        do_loop = False
    else:
        case_sensitive = input('Casesensitive (yes):')
        if case_sensitive == 'yes':
            where_clause = f"""WHERE `city` LIKE BINARY '%{search_criteria}%'"""
        else:
            where_clause = f"""WHERE `city` LIKE '%{search_criteria}%'"""

        sql_stmt = f"""
            SELECT
                `c`.`city_id`     AS `ID`,
                `c`.`city`        AS `City_Name`,
                `c`.`country_id`  AS `Country_ID`,
                `c`.`last_update` AS `Last_Update`
            FROM `city` AS `c`
            {where_clause};
        """

        my_cursor = db_connection.cursor(dictionary=True)
        my_cursor.execute(sql_stmt)
        my_resultset = my_cursor.fetchall()

        for a_tuple in my_resultset:
            print(a_tuple['City_Name'])

        print('==>', len(my_resultset))
