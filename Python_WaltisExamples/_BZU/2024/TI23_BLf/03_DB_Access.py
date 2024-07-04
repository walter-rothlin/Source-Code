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

def convert_resultSet_to_insertSQL(table_name, result_set=None, fields_to_hash=None, verbal=False):

    if fields_to_hash is None:
        fields_to_hash = []

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

                if an_attr_name in fields_to_hash:
                    if an_attr_value is not None and len(an_attr_value) > 0:
                        if is_email(an_attr_value):
                            email_part_0 = an_attr_value.split('@')[0]
                            email_part_1 = an_attr_value.split('@')[1]
                            value_of_attr_hash = hash_string(email_part_0, ret_length=len(email_part_0))
                            value_of_attr_hash_1 = an_attr_value[0] + value_of_attr_hash[1:] + '@' + email_part_1
                            an_attr_value = value_of_attr_hash_1
                        else:
                            value_of_attr_hash = hash_string(an_attr_value, ret_length=len(an_attr_value))
                            value_of_attr_hash_1 = an_attr_value[0] + value_of_attr_hash[1:]
                            if verbal:
                                print(f'         {an_attr_name}={an_attr_value} HASH: {value_of_attr_hash} : {value_of_attr_hash_1}')
                            an_attr_value = value_of_attr_hash_1
                # print(f'{a_attr}={value_of_attr}  [{type_of_attr}]')

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

            tuple_str = "   " + tuple_str[:-2] + "),\n"
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


def do_prepare_db_attributes(attributes_to_select=None, indent=4):
    if isinstance(indent, int):
        indent = f'{" ":{indent}s}'

    ret_str = ''
    if attributes_to_select is None:
        ret_str = "*"
    elif isinstance(attributes_to_select, str):
        ret_str = attributes_to_select
    elif isinstance(attributes_to_select, list):
        ret_str = f',\n{indent}'.join(attributes_to_select)

    ret_str = f'\n{indent}{ret_str}'
    return ret_str


def do_prepare_order_by(order_by=None, indent=4):
    if isinstance(indent, int):
        indent = f'{" ":{indent}s}'

    ret_str = ''
    if order_by is None:
        ret_str = ""
    elif isinstance(order_by, str):
        ret_str = order_by
    elif isinstance(order_by, list):
        ret_str = f',\n{indent}'.join(order_by)

    if ret_str != '':
        ret_str = '\nORDER BY\n' + indent + ret_str
    return ret_str


def select_data_from_db_table(db_connection,
                              table_name,

                              attribute_list=None,
                              where_clause=None,
                              order_by_list=None,

                              db_type='MySql',
                              indent=4,
                              dictionary=True,
                              verbal=False):

    if isinstance(indent, int):
        indent = f'{" ":{indent}s}'
        # print(':', indent, ':', sep='')

    if where_clause is None:
        where_clause = ''
    else:
        where_clause = f"\nWHERE\n{indent}{where_clause}"

    sql_statement = f"""SELECT {do_prepare_db_attributes(attribute_list, indent=indent)}\nFROM {table_name} {where_clause} {do_prepare_order_by(order_by_list, indent=indent)};"""

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

def unload_data_from_db_table(db_connection,
                              table_name,
                              attribute_list=None,
                              where_clause=None,
                              order_by_list=None,
                              fields_to_hash=None,
                              verbal=False
                              ):

    rs = select_data_from_db_table(db_connection,
                                   table_name=table_name,
                                   attribute_list=attribute_list,
                                   where_clause=where_clause,
                                   order_by_list=order_by_list,
                                   verbal=verbal
                                   )
    insert_string = convert_resultSet_to_insertSQL(
                                   table_name,
                                   rs['rs'],
                                   fields_to_hash=fields_to_hash,
                                   verbal=verbal
                                   )
    insert_string = f"""
-- Extracted at: {rs['timestamp']}
-- Count       : {rs['count']}
/*
{rs['select']}
*/
{insert_string}

    """
    return insert_string

def get_exception_for_table_unload(table_name, exception_list, verbal=False):
    if verbal:
        print(f'''
        get_exception_for_table_unload('{table_name}', {exception_list}, {verbal} has been called)
        ''')

    ret_exception = None
    for an_exception in exception_list:
        if an_exception['table'].lower() == table_name.lower():
            ret_exception = an_exception
            break

    return ret_exception

def unload_all_data_from_schema(db_connection,
        schema_name=None,
        tables_to_read_with_exceptions=None,
        verbal=False):

    obj_type = 'BASE TABLE'
    all_tables = get_all_table_names_from_schema(db_connection, schema=schema_name, object_types=obj_type, verbal=False)
    if verbal:
        print(f'{len(all_tables)} "{obj_type}" found in "{schema_name}"!')

    max_len = 0
    for a_table_name in all_tables:
        length = len(a_table_name[1])
        if length > max_len:
            max_len = length
    max_table_name_length = f'{max_len}s'

    insert_string = ''
    for a_table in all_tables:
        if verbal:
            print(f'a_table: {a_table}')
        exception = get_exception_for_table_unload(a_table[1], tables_to_read_with_exceptions, verbal=False)

        if exception is not None:
            if verbal:
                print(f'    Exceptions for "{a_table[1]}" found\n{exception}')
            if exception.get('action') == 'Exclude':
                print(f'WARNING: {a_table[1]:{max_table_name_length}} Data not extracted!')
                continue
            fields_to_select = exception.get('fields')
            where_clause = exception.get('where_clause')
            do_verbal = exception.get('verbal')
            fields_to_hash = exception.get('fields_to_hash')
            # print(f'Parameter: {a_table[1]} {fields_to_select} {where_clause} {do_verbal}')
            print(f'WARNING: {a_table[1]:{max_table_name_length}} Data with exceptions extracted')
            insert_string += "\n\n" + unload_data_from_db_table(
                db_connection,
                table_name=a_table[1],
                attribute_list=fields_to_select,
                where_clause=where_clause,
                order_by_list=None,
                fields_to_hash=None,
                verbal=False
            )

            # insert_str += create_insert_data_stmt(db_schema, table_name=a_table[1], where_clause=where_clause, fields_to_select=fields_to_select, fields_to_hash=fields_to_hash, verbal=do_verbal)
        else:
            print(f'INFO   : {a_table[1]:{max_table_name_length}} Data extracted from ')
            # insert_str += create_insert_data_stmt(db_schema, table_name=a_table[1], where_clause=None)
    return insert_string
# -------------------------------------------
# ++++++++++++ Main Main Main +++++++++++++++
# -------------------------------------------
if __name__ == '__main__':
    db_connection = do_db_connect(user='TI23_B', password='TI23_B')
    insert_string = unload_data_from_db_table(
                        db_connection,
                        table_name='customer',
                        attribute_list=['customer_id', 'first_name', 'last_name', 'email'],
                        where_clause=None,
                        order_by_list=None,
                        fields_to_hash=['first_name', 'email'],
                        verbal=False
                    )


    insert_string += "\n\n" + unload_data_from_db_table(
                        db_connection,
                        table_name='`city` AS `c`',
                        attribute_list=["`c`.`country_id` AS `Country_ID`",
                                        "`c`.`city`       AS `City_Name`"],
                        where_clause="`city` LIKE 'O%'",
                        order_by_list=['Country_ID', 'City_Name'],
                        fields_to_hash=None,
                        verbal=False
                    )


    insert_string += "\n\n" + unload_data_from_db_table(
                        db_connection,
                        table_name='language',
                        verbal=False
                    )
    print(insert_string)


    tables_to_read_with_exceptions = [
        {'table': 'country', 'action': 'Exclude'},
        {'table': 'customer', 'fields': ['customer_id', 'first_name', 'last_name', 'email'], 'fields_to_hash': ['first_name', 'email'], 'verbal': True},
        {'table': 'Personen', 'fields_to_hash': ['Vorname', 'Ledig_Name', 'Partner_Name'], 'where_clause': "ID IN (644)", 'verbal': True},
        {'table': 'Personen', 'fields_to_hash': ['Vorname', 'Ledig_Name', 'Partner_Name'], 'verbal': False},
        {'table': 'Email_Adressen', 'fields_to_hash': ['eMail'], 'verbal': True},
    ]

    insert_string = unload_all_data_from_schema(
        db_connection=db_connection,
        schema_name='sakila',
        tables_to_read_with_exceptions=tables_to_read_with_exceptions,
        verbal=True)

    print(insert_string)
