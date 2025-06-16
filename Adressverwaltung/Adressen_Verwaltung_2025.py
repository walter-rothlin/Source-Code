#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Adressen_Verwaltung_2025.py
#
# Description: Applikation für management von Adressen im eigenen Schema.
#
# Autor: Walter Rothlin
#
# History:
# 15-May-2025   Walter Rothlin      Initial Version
# 22-May-2025   Walter Rothlin      Added YAML config file
# 12-Jun-2025   Walter Rothlin      Added connection into a reusable function
# ------------------------------------------------------------------
import mysql.connector
import sqlparse
from tabulate import tabulate
import yaml
import os
import re

# Function to connect to the database using a YAML configuration file
def db_connect(config_file='App_Config.yaml'):
    """Connect to the database using configuration from a YAML file."""
    if not config_file:
        raise ValueError("Config file path must be provided.")

    if not os.path.exists(config_file):
        print(f"❌ Datei '{config_file}' nicht gefunden!")
        return None

    with open(config_file, "r") as file:
        db_config = yaml.safe_load(file)

    schema_name = str(db_config['database']['schema'])
    print(f'Connecting to {schema_name}....', end='', flush=True)

    db_connection = mysql.connector.connect(
        host=db_config['database']['host'],
        user=db_config['database']['user'],
        password=db_config['database']['password'],
        database=schema_name,
        auth_plugin=db_config['database']['auth_plugin'],
    )

    print('completed!')
    return db_connection

def format_sql_select(sql_query: str, keyword_case: str = 'upper', identifier_case: str = None) -> str:
    """
    Formats a raw SQL SELECT query into a more readable format.

    Args:
        sql_query (str): Raw SQL SELECT query string.
        keyword_case (str, optional): Case to convert SQL keywords to ('upper', 'lower', 'capitalize', or None).
        identifier_case (str, optional): Case to convert identifiers (e.g., table/column names).
                                         Use 'lower', 'upper', or None to preserve case.

    Returns:
        str: Nicely formatted SQL query.
    """
    formatted_query = sqlparse.format(
        sql_query,
        reindent=True,
        keyword_case=keyword_case,
        identifier_case=identifier_case
    )
    return formatted_query


def add_indent(multi_line_string, indent_str='   '):
    """
    Adds indentation to each line of a multi-line string.

    Parameters
    ----------
    multi_line_string : str
        The string to indent, which may contain multiple lines.

    indent_str : str
        The string to use for indentation. Defaults to '    '.

    Returns
    -------
    str
        The indented string.
    """

    return '\n'.join(indent_str + line for line in multi_line_string.splitlines())


def select_from_table(db_connection, table_name='adressen', search_field_name='Search_Field',
                      fields=None, filter_string=None, search_case_sensitive=False):
    """
    Selects records from a specified SQL table with optional filtering and selected fields.

    Parameters
    ----------
    db_connection : object
        A live database connection object that supports the `cursor()` interface.

    table_name : str, optional
        The name of the table to query from.
        Must be a valid SQL identifier. Defaults to 'adressen'.

    search_field_name : str, optional
        The name of the field to search/filter against.
        Must be a valid SQL identifier. Defaults to 'Search_Field'.

    fields : list[str], optional
        A list of column names to include in the SELECT statement.
        Each entry can optionally include an alias using 'AS'.
        If None or empty, all columns (*) will be selected.

        Examples:
        ---------
        - fields = ["Name", "PLZ", "Ort"]
        - fields = ["Name AS FullName", "Ort AS City"]

    filter_string : str, optional
        A logical search string used to filter rows via the specified `search_field_name`.
        Terms are matched using SQL `LIKE` or `LIKE BINARY`.

        Behavior:
        - Words separated by spaces are treated as AND (e.g., "Berlin Mitte")
        - You may use `AND` or `OR` explicitly (case-insensitive)
        - Parentheses or nested expressions are not supported

        Examples:
        ---------
        - "Berlin" → matches rows where `Search_Field` contains "Berlin"
        - "Berlin Mitte" → matches rows containing both "Berlin" AND "Mitte"
        - "Berlin OR Hamburg" → matches rows containing either "Berlin" OR "Hamburg"
        - "Berlin AND Mitte OR Kreuzberg" → ((Berlin AND Mitte) OR Kreuzberg)

    search_case_sensitive : bool, default False
        If True, performs a case-sensitive search using `LIKE BINARY`.
        If False, uses case-insensitive `LIKE`.

    Returns
    -------
    results : list[tuple]
        The list of rows that match the query conditions.

    description : tuple
        Metadata about the result columns (name, type, etc.).
    """
    # Basic identifier validation (optional)
    if not re.match(r'^\w+$', table_name):
        raise ValueError(f"Invalid table name: {table_name}")
    if not re.match(r'^\w+$', search_field_name):
        raise ValueError(f"Invalid search field name: {search_field_name}")

    # Prepare SELECT fields
    if not fields:
        fields_with_alias = '*'
    else:
        fields_with_alias_parts = []
        for f in fields:
            match = re.match(r'^(\w+)(\s+AS\s+\w+)?$', f, re.IGNORECASE)
            if not match:
                raise ValueError(f"Invalid field syntax: '{f}'")
            base_field, alias_part = match.group(1), match.group(2)
            field_sql = f"`{base_field}`"
            if alias_part:
                field_sql += alias_part  # ' AS alias'
            fields_with_alias_parts.append(field_sql)
        fields_with_alias = ', '.join(fields_with_alias_parts)

    like_operator = 'LIKE BINARY' if search_case_sensitive else 'LIKE'
    params = []

    # Handle filter string
    if not filter_string:
        select_stmt = f"SELECT {fields_with_alias} FROM `{table_name}`;"
        print(f"Executing SQL: {select_stmt}")
        cursor = db_connection.cursor(dictionary=False)
        cursor.execute(select_stmt)
        results = cursor.fetchall()
        return results, cursor.description

    # Tokenize filter string
    tokens = re.findall(r'\w+|AND|OR', filter_string, flags=re.IGNORECASE)
    where_parts = []

    for token in tokens:
        upper_token = token.upper()
        if upper_token in ('AND', 'OR'):
            where_parts.append(upper_token)
        else:
            where_parts.append(f"`{search_field_name}` {like_operator} %s")
            params.append(f"%{token}%")

    where_clause = " WHERE " + " ".join(where_parts)
    select_stmt = f"SELECT {fields_with_alias} FROM `{table_name}`{where_clause};"

    print(format_sql_select(select_stmt))
    print(f"Executing SQL: {select_stmt} with params {params}")

    cursor = db_connection.cursor(dictionary=False)
    cursor.execute(select_stmt, params)
    results = cursor.fetchall()
    return results, cursor.description



# ================
# Haupt-Programm
# ================
if __name__ == "__main__":

    menu_text = f'''
      Adressverwaltung (V1.0)
      =======================
      1: Person suchen
      2: Neue Person erfassen
      3: Person löschen
      4: Person ändern
    
      0: Schluss
    '''

    db_connection = db_connect('App_Config.yaml')

    do_loop = True
    while do_loop:
        print(menu_text)
        in_value = input('Bitte Auswahl treffen: ')
        if in_value == '0':
            do_loop = False
            continue
        elif in_value == '1':
            search_string = input('Suchbegriff eingeben: ')
            my_results, cursor_description = select_from_table(db_connection, filter_string=search_string)
            ## print(cursor_description)

            # nice table output
            column_names = [desc[0] for desc in cursor_description]
            print("\nAdressen:")
            print(tabulate(my_results, headers=column_names, tablefmt="grid"))
        elif in_value == '2':
            print('TODO: Neue Person erfassen')
        elif in_value == '3':
            print('TODO: Person löschen')
        elif in_value == '4':
            print('TODO: Person ändern')
        else:
            print(f'ERROR: Ungültige Auswahl {in_value}')
