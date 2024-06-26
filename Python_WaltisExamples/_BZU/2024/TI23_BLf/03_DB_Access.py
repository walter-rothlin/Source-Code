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
import datetime
import mysql.connector # mysql-connector-python

def do_connect(password, host='localhost', user='TI23_B', database='sakila', verbal=False):
    if verbal:
        print(f'Connecting to {database}...', end='', )
    db_connection = mysql.connector.connect(
        host=host,
        user=user,    # 'root',
        password=password,    # 'admin',
        database=database,
        auth_plugin='mysql_native_password'
    )
    if verbal:
        print('connected!')
    return db_connection

def select_data(db_connection, table_name, where_clause=None, dictionary=True, verbal=True):
    if where_clause is None:
        where_clause = ''
    else:
        where_clause = f"WHERE {where_clause}"

    sql_stmt = f"""
        SELECT
            *
        FROM `{table_name}`
        {where_clause};
            """
    if verbal:
        print(sql_stmt)

    my_cursor = db_connection.cursor(dictionary=dictionary)
    my_cursor.execute(sql_stmt)
    result_set = my_cursor.fetchall()
    return {
        'timestamp': f'{datetime.datetime.now():%Y-%m-%d %H:%M:%S}',
        'count': len(result_set),
        'select': sql_stmt,
        'rs': result_set
    }



def search_city():
    do_loop = True
    while do_loop:
        search_criteria = input('Suchmster [% or _ possible] (STOP):')
        if search_criteria == 'STOP':
            do_loop = False
        else:
            case_sensitive = input('Casesensitive (yes/no):')
            if case_sensitive == 'yes':
                where_clause = f"""WHERE `city` LIKE BINARY '{search_criteria}'"""
            else:
                where_clause = f"""WHERE `city` LIKE '{search_criteria}'"""

            sql_stmt = f"""
                SELECT
                    `c`.`city_id`     AS `ID`,
                    `c`.`city`        AS `City_Name`,
                    `c`.`country_id`  AS `Country_ID`,
                    `c`.`last_update` AS `Last_Update`
                FROM `city` AS `c`
                {where_clause};
            """

            print(sql_stmt)

            my_cursor = db_connection.cursor(dictionary=True)
            my_cursor.execute(sql_stmt)
            my_resultset = my_cursor.fetchall()

            for a_tuple in my_resultset:
                print(a_tuple['City_Name'])

            print('==>', len(my_resultset))


# =============
# Hauptprogramm
# =============
db_connection = do_connect(password='TI23_B')

rs = select_data(db_connection, 'city', where_clause="`city` LIKE 'O%'")
print(rs)

print(rs['rs'][1]['city'])



