#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 01_SelectSakila.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_08_MySql/01_SelectSakila.py
#
# Description: Connects to sakila and queries data
#
# Autor: Walter Rothlin
#
# History:
# 26-May-2020   Walter Rothlin      Initial Version
# 11-Jun-2024   Walter Rothlin      Changes for BZU-A21
# ------------------------------------------------------------------
#
# Install driver first: python -m pip install mysql-connector-python
import mysql.connector  # mysql-connector-python not default mässiger one

print("Connecting to sakila....", end="", flush=True)
db_connection = mysql.connector.connect(
  host        = "localhost",
  user        = "root",    # "Test_APP_2023_B",
  password    = "admin",   # "Test_APP_2023_B",
  database    = "sakila",
  auth_plugin = 'mysql_native_password'
)
print("completed!")

stm_selectCities = """
    SELECT
       `city_id`    AS `ID`,
       `city`       AS `Ortsname`,
       `country_id` AS `Country`
    FROM 
       `city`
    WHERE 
       `city` like 'O%'
"""

rs_as_dict = False
print(f"{stm_selectCities}\nResult-Set as Hash: {rs_as_dict}\n")

my_cursor = db_connection.cursor(dictionary=rs_as_dict)
my_cursor.execute(stm_selectCities)
my_results = my_cursor.fetchall()

print("Records found:", len(my_results), my_results)
print("+------+--------------------------------+------------+")
print("| Id   | City                           | Country ID |")
print("+------+--------------------------------+------------+")

for a_tuple in my_results:
    if rs_as_dict:
            print(f"| {a_tuple['ID']:4d} | {a_tuple['Ortsname']:30s} | {a_tuple['Country']:10d} |")
    else:
            print("| {plh:4d} |".format(plh=a_tuple[0]), end="")
            print(" {plh:30s} |".format(plh=a_tuple[1]), end="")
            print(" {plh:10d} |".format(plh=a_tuple[2]), end="")
            print()

print("+------+--------------------------------+------------+")




