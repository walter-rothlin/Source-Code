#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 01_SimpleSelect_MS_Access.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_08b_DB_MSAccess/01_SimpleSelect_MS_Access.py
#
# Description: Connects to a MS-Access DB and queries data
#
# Autor: Walter Rothlin
#
# History:
# 22-Jun-2024   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
#
import pyodbc

# Replace with the path to your .mdb or .accdb file
db_file_path = r'C:\Users\Landwirtschaft\Documents\SoruceCode\Python_WaltisExamples\Code_08b_DB_MSAccess\Data\sample.mdb'
db_file_path = r'V:\EDV\Bürgerdaten_Access\GW_data_2023_06_01.mdb'

# Connection string for Access Database
conn_str = (
    r'DRIVER={Microsoft Access Driver (*.mdb, *.accdb)};'
    rf'DBQ={db_file_path};'
)

try:
    # Establish the connection
    conn = pyodbc.connect(conn_str)
    print("Connection successful!")

    # Create a cursor object to interact with the database
    cursor = conn.cursor()

    # Execute a query
    # cursor.execute('SELECT * FROM customers')
    cursor.execute('SELECT * FROM tblPersonen')

    # Fetch and display the results
    rows = cursor.fetchall()
    for row in rows:
        print(row)

    # Close the cursor and connection
    cursor.close()
    conn.close()
    print("Connection closed.")
except Exception as e:
    print(f"An error occurred: {e}")
