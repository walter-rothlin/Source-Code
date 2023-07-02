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
# ------------------------------------------------------------------
#
# Install driver first: python -m pip install mysql-connector-python
import mysql.connector  # mysql-connector-python not default mässiger one

print("Connecting to sakila....", end="", flush=True)
mydb = mysql.connector.connect(
  host        = "localhost",
  user        = "Test_APP_2023_B",
  password    = "Test_APP_2023_B",
  database    = "sakila",
  auth_plugin = 'mysql_native_password'
)
print("completed!")

stm_selectCities = """
    SELECT
       city_id    AS ID,
       city       AS Name,
       country_id AS Country
    FROM 
       city
    WHERE 
       city like 'O%'
"""

print(stm_selectCities)

mycursor = mydb.cursor()
mycursor.execute(stm_selectCities)
myresult = mycursor.fetchall()
print("Records found:", len(myresult), myresult)

print("+------+--------------------------------+------------+")
print("| Id   | City                           | Country ID |")
print("+------+--------------------------------+------------+")
for aRec in myresult:
    print("| {plh:4d} |".format(plh=aRec[0]), end="")
    print(" {plh:30s} |".format(plh=aRec[1]), end="")
    print(" {plh:10d} |".format(plh=aRec[2]), end="")
    print()
    print("+------+--------------------------------+------------+")
