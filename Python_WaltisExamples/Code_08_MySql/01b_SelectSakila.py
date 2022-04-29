#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 01b_SelectSakila.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_08_MySql/01b_SelectSakila.py
#
# Description: Connects to sakila and queries data by attribute names
#
# Autor: Walter Rothlin
#
# History:
# 26-May-2020   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

# Install driver first: python -m pip install mysql-connector-python
import mysql.connector  # mysql-connector-python not default mässiger one

print("Connecting to sakila....", end="", flush=True)
mydb = mysql.connector.connect(
  host        = "localhost",
  user        = "root",
  password    = "admin",
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

mycursor = mydb.cursor(dictionary=True)
mycursor.execute(stm_selectCities)
myresult = mycursor.fetchall()

print("Records found:", len(myresult), myresult)

print("+------+--------------------------------+------------+")
print("| Id   | City                           | Country ID |")
print("+------+--------------------------------+------------+")
for aRec in myresult:
    print("| {plh:4d} |".format(plh=aRec['ID']), end="")
    print(" {plh:30s} |".format(plh=aRec['Name']), end="")
    print(" {plh:10d} |".format(plh=aRec['Country']), end="")
    print()
    print("+------+--------------------------------+------------+")

