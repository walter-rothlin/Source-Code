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
from waltisLibrary import *


# -------------------------------------------
# ++++++++++++ Main Main Main +++++++++++++++
# -------------------------------------------
if __name__ == '__main__':
    schema_name = 'sakila'
    db_connection = do_db_connect(user='TI23_B', password='TI23_B')

    sakila_tables_to_read_with_exceptions = [
        {'table': 'country',  'action': 'Exclude'},
        {'table': 'customer', 'fields': ['customer_id', 'first_name', 'last_name', 'email'],
                              'fields_to_hash': ['first_name', 'email'], 'verbal': False},
        {'table': 'address',  'fields': ['address_id', 'address', 'address2', 'district', 'city_id', 'postal_code', 'phone', 'last_update'], 'verbal': False},    # location is geometry
        {'table': 'staff',    'fields': ['staff_id', 'first_name', 'last_name', 'address_id', 'email', 'store_id', 'active', 'username', 'password', 'last_update'], 'verbal': False},  # picture is BLOP
    ]

    insert_string = unload_all_data_from_schema(
        db_connection=db_connection,
        schema_name=schema_name,
        tables_to_read_with_exceptions=sakila_tables_to_read_with_exceptions,
        verbal=True)

    ## print(insert_string)

    insert_string = f'''-- From script 03_DB_Access.py (V1.0)
    -- ==================================
    SET FOREIGN_KEY_CHECKS = 0;
    {insert_string}
    SET FOREIGN_KEY_CHECKS = 1;
    '''
    file_name = addTimestampToFileName(f'{schema_name}_Extract.sql')
    if len(sakila_tables_to_read_with_exceptions) > 0:
        file_name = addTimestampToFileName(f'{schema_name}_Extract_With_Exceptions.sql')
    File_create(file_name, insert_string, verbal=True)
