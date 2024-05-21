#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 01_DB_Access.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_HWZ/BWI_22/01_DB_Access.py
#
# Description: Connects to sakila and queries data
#
# Autor: Walter Rothlin
#
# History:
# 21-May-2024   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
#
# Install driver first: python -m pip install mysql-connector-python
import mysql.connector  # mysql-connector-python not default mässiger one

def halt():
  return input('Weiter?')


def insert_city(plz, city_name):
  sql_insert = f"""
  INSERT INTO `orte` (`PLZ`, `Ortsname`) VALUES 
      ('{plz}', '{city_name}');
  """
  print(sql_insert)
  my_cursor.execute(sql_insert)
  mydb.commit()
  print('Done')
  halt()


connection_properties = {
  'host': 'localhost',
  'user': 'Test_APP_2024',
  'password': 'BWI-A22',
  'database': 'HWZ_2024',
  'auth_plugin': 'mysql_native_password',

}
print(f"Connecting to '{connection_properties['database']}'@{connection_properties['host']}....", end="", flush=True)
mydb = mysql.connector.connect(
  host        = connection_properties['host'],
  user        = connection_properties['user'],
  password    = connection_properties['password'],
  database    = connection_properties['database'],
  auth_plugin = connection_properties['auth_plugin']
)
print("completed!")

if True:
  my_cursor = mydb.cursor(dictionary=True)

  select_statement = f"""
  SELECT
    *
  FROM `Orte`;
  """

  my_cursor.execute(select_statement)
  result_set = my_cursor.fetchall()
  print(f'Tuples found: {len(result_set)}')
  for a_tuple in result_set:
    print(a_tuple)


my_cursor = mydb.cursor(dictionary=True)
select_statement = f"""
SELECT
  `Vorname`  AS `Firstname`,
  `Nachname` AS `Lastname`
FROM `Adresse_View`;
"""

my_cursor.execute(select_statement)
result_set = my_cursor.fetchall()
print(f'Tuples found: {len(result_set)}')

pi = 3.1415926
spaltenbreite = 10
print('1234567890123456789012345678901234567890')
for a_tuple in result_set:
    print(f'|{a_tuple["Firstname"]:{spaltenbreite}s}|{a_tuple["Lastname"]:{spaltenbreite}s}|{pi:7.3f}|')

insert_city('9469', 'Hag')

sql_update = f"""
UPDATE `orte` SET `Ortsname` = 'Haag' WHERE `Ortsname` = 'Hag'
"""

my_cursor.execute(sql_update)
mydb.commit()
print('Done')
halt()


