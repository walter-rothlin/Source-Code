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
# 27-Jun-2024   Walter Rothlin      Merged VersionTI23_BLf
# 04-Jul-2024   Walter Rothlin      Added Fct to convert JSON to insert_statement convert_resultSet_to_insertSQL()
# ------------------------------------------------------------------
#
from waltisLibrary import *


# import datetime
# import mysql.connector # mysql-connector-python

def convert_resultSet_to_insertSQL(table_name, result_set=None, verbal=True):
    insert_str = ""
    if result_set is not None and len(result_set) > 0:
        insert_str = f"INSERT INTO `{table_name}` ("
        attr_list = list(result_set[0].keys())
        for a_attr_name in attr_list:
            insert_str += f"`{a_attr_name}`, "

        insert_str = insert_str[:-2] + ") VALUES\n"

        for a_tuple in result_set:
            tuple_str = '('
            for an_attr_name in attr_list:
                an_attr_value = a_tuple[an_attr_name]

                if isinstance(an_attr_value, str):
                    an_attr_value = an_attr_value.replace("'", r"\'")
                    tuple_str += f"'{an_attr_value}'" + ', '

                elif an_attr_value is None:
                    tuple_str += 'NULL' + ', '

                elif isinstance(an_attr_value, datetime.datetime):
                    tuple_str += f"STR_TO_DATE('{an_attr_value}', '%Y-%m-%d %H:%i:%s')" + ', '

                elif isinstance(an_attr_value, datetime.date):
                    tuple_str += f"STR_TO_DATE('{an_attr_value}', '%Y-%m-%d')" + ', '

                elif isinstance(an_attr_value, set):
                    if verbal:
                        print(f"\nWARNING is a set: {an_attr_name}: {an_attr_value}")

                    an_attr_value = str(an_attr_value)
                    if an_attr_value == 'set()':
                        # print(attr_value)
                        tuple_str += 'NULL' + ', '
                    else:
                        an_attr_value = an_attr_value.replace("', '", ",")
                        an_attr_value = an_attr_value[:-2]  # .replace(r"'{", "")
                        an_attr_value = an_attr_value[2:]  # .replace(r"}'", "")
                        # attr_value = attr_value.replace("'", "'")
                        an_attr_value = f"'{an_attr_value}'" + ', '
                        tuple_str += an_attr_value
                else:
                    tuple_str += f"{str(an_attr_value)}, "

            tuple_str = "       " + tuple_str[:-2] + "),\n"
            insert_str += tuple_str
        insert_str = insert_str[:-2] + ";"
    else:
        insert_str = ""
    return insert_str


def do_db_connect(password,
                  user,
                  host='localhost',
                  port=3306,
                  schema='sakila',
                  db_type='MySql', verbal=False):
    if db_type == 'MySql':
        if verbal:
            print(f'Connecting to {user}@{host} --> {schema}...', end='', )
        db_connection = mysql.connector.connect(
            host=host,
            user=user,
            password=password,
            database=schema,
            port=port,
            auth_plugin='mysql_native_password'
        )
        if verbal:
            print('....connected!')

    if db_type == 'Access':
        pass

    return db_connection


def do_prepare_db_attributes(attributes_to_select=None, indent=8):
    if isinstance(indent, int):
        indent = f'{" ":{indent}s}'
        # print(':', indent, ':', sep='')

    ret_str = ''
    if attributes_to_select is None:
        ret_str = "*"
    elif isinstance(attributes_to_select, str):
        ret_str = attributes_to_select
    elif isinstance(attributes_to_select, list):
        ret_str = f',\n{indent}'.join(attributes_to_select)
    return ret_str


def do_prepare_order_by(order_by=None, indent=8):
    if isinstance(indent, int):
        indent = f'{" ":{indent}s}'
        # print(':', indent, ':', sep='')

    ret_str = ''
    if order_by is None:
        ret_str = ""
    elif isinstance(order_by, str):
        ret_str = order_by
    elif isinstance(order_by, list):
        ret_str = f',\n{indent}'.join(order_by)

    if ret_str != '':
        ret_str = 'ORDER BY\n' + indent + ret_str
    return ret_str


def select_data_from_db_table(db_connection,
                              table_name,

                              attribute_list=None,
                              where_clause=None,
                              order_by_list=None,

                              db_type='MySql',
                              indent=8,
                              dictionary=True,
                              verbal=True):
    if isinstance(indent, int):
        indent = f'{" ":{indent}s}'
        # print(':', indent, ':', sep='')

    if where_clause is None:
        where_clause = ''
    else:
        where_clause = f"WHERE\n{indent}{where_clause}"

    sql_statement = f"""
    SELECT
        {do_prepare_db_attributes(attribute_list)}
    FROM {table_name}
    {where_clause}
    {do_prepare_order_by(order_by_list)};
    """

    if verbal:
        print(sql_statement)

    my_cursor = db_connection.cursor(dictionary=dictionary)
    my_cursor.execute(sql_statement)
    my_resultset = my_cursor.fetchall()
    if verbal:
        print(f"{len(my_resultset)} record(s) found")
    return {
        'timestamp': f'{datetime.datetime.now():%Y-%m-%d %H:%M:%S}',
        'count': len(my_resultset),
        'select': sql_statement,
        'rs': my_resultset
    }


# -------------------------------------------
# ++++++++++++ Main Main Main +++++++++++++++
# -------------------------------------------
if __name__ == '__main__':
    db_connection = do_db_connect(user='TI23_B', password='TI23_B')

    rs = select_data_from_db_table(db_connection,
                                   table_name='city AS c',
                                   # attribute_list="`c`.`country_id` AS `Country_ID`",
                                   # attribute_list=["`c`.`country_id` AS `Country_ID`",
                                   #                "`c`.`city` AS `City_Name`"],
                                   # order_by_list=['Country_ID', 'City_Name'],
                                   where_clause="`city` LIKE 'O%'")
    print(f"{rs['timestamp']}")
    print(f"{rs['select']}")
    print(f"{rs['count']}")
    print('\n')
    print(rs['rs'][1])

    print('\n')
    print(f'''
    do_prepare_db_attributes() = 
    {do_prepare_db_attributes()}
    ''')

    print(f'''
    do_prepare_db_attributes("`c`.`country_id`   AS `Country_ID`") = 
    {do_prepare_db_attributes("`c`.`country_id`   AS `Country_ID`")}
    ''')

    print(f'''
    do_prepare_db_attributes(["`c`.`country_id`   AS `Country_ID`", "`c`.`city`         AS `City_Name`"]) =
    {do_prepare_db_attributes(["`c`.`country_id`   AS `Country_ID`", "`c`.`city`         AS `City_Name`"])}
    ''')

    print('\n\n\n\n\n\n\n\n\n\n\n\n')
    rs = select_data_from_db_table(db_connection,
                                   table_name='film',
                                   attribute_list=['film_id', 'special_features'])
    insert_string = convert_resultSet_to_insertSQL('film', rs['rs'])
    print('\n\n\n\n\n\n\n\n\n\n\n\n')
    insert_string = f"""
    -- Extracted at: {rs['timestamp']}
    -- Count:        {rs['count']}
    /*
    {rs['select']}
    */
    {insert_string}

    """
    print(insert_string)



