#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: BWI_A23_Rothlin_Walter_Adressen.py
#
# Description: Connects to BZU/HWZ Schema and manages Adress
#
# Autor: Walter Rothlin
#
# History:
# 20-May-2025   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
import mysql.connector
import yaml
import os

def db_connect(hostname = 'localhost', username = None, password = None, schema_name = None, config_file =  None):
    config = {}
    if config_file is None:
        config = {'database':
                      { 'host': hostname,
                        'user': username,
                        'password': password,
                        'schema':schema_name,
                        'auth_plugin': 'mysql_native_password'
                      }
                  }

    elif not os.path.exists(config_file):
        print(f"❌ Datei '{config_file}' nicht gefunden!")
        return None

    else:
        with open(config_file, "r") as file:
            config = yaml.safe_load(file)

    print(f"Config: {config}")


    db_cfg = config['database']
    host = db_cfg['host']
    user = db_cfg['user']
    password = db_cfg['password']
    schema_name = db_cfg['schema']


    print(f'Connecting to {host} and {user}@{schema_name}....', end='', flush=True)
    db_connection = mysql.connector.connect(
          host=host,
          user=user,
          password=password,
          database=schema_name,
          auth_plugin='mysql_native_password'
    )
    print('completed!')

    return db_connection

# ================
# Haupt-Programm
# ================
db_connection = db_connect(config_file = 'BWI_A23.yaml')
db_connection = db_connect(username='BWI_A23', password = '123456789', schema_name = 'hwz')

select_adressen = f"""
SELECT 
    `adress_id` AS `ID`,
    `Vorname`   AS `Firstname`
FROM `adressen`
WHERE `Nachname` = 'Rothlin';
"""
my_cursor = db_connection.cursor(dictionary=True)
my_cursor.execute(select_adressen)
my_results = my_cursor.fetchall()
print(my_results)
for aTuple in my_results:
    print(f"{aTuple['ID']} | {aTuple['Firstname']}")
