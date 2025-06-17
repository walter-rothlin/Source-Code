#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: TI24BLe_Rothlin_Walter_Adressen.py
#
# Description: Connects to BZU/HWZ Schema and manages Adress
#
# Autor: Walter Rothlin
#
# History:
# 16-May-2025   Walter Rothlin      Initial Version
# 23-May-2025   Walter Rothlin      Added YAML config file
# ------------------------------------------------------------------
import mysql.connector
from tabulate import tabulate
import yaml

db_config_json = {}

with open('App_Config.yaml', "r") as file:
    db_config_json = yaml.safe_load(file)

# print(db_config_json)

schema_name = str(db_config_json['database']['schema'])
print(f'Connecting to {schema_name}....', end='', flush=True)
db_connection = mysql.connector.connect(
  host        = str(db_config_json['database']['host']),
  user        = str(db_config_json['database']['user']),
  password    = str(db_config_json['database']['password']),
  database    = schema_name,
  auth_plugin = str(db_config_json['database']['auth_plugin']),
)
print('completed!')

select_stmt ="""
  SELECT * FROM `Adressen`;
"""

my_cursor = db_connection.cursor(dictionary=False)
my_cursor.execute(select_stmt)
my_results = my_cursor.fetchall()
print(my_results)

# nice table output
column_names = [desc[0] for desc in my_cursor.description]
print("\nAdressen:")
print(tabulate(my_results, headers=column_names, tablefmt="grid"))