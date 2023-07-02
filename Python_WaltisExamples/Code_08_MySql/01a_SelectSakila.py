#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 01a_SelectSakila.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_08_MySql/01a_SelectSakila.py
#
# Description: Connects to sakila with wrong password or unknown user
#
# Autor: Walter Rothlin
#
# History:
# 28-Apr-2022   Walter Rothlin      Initial Version
# 22-Jun_2023   Walter Rothlin      Added dictionary=True for result set
# ------------------------------------------------------------------
import mysql.connector
from waltisLibrary import *

db_host      = "localhost"
db_schema    = "sakila"
db_user_name = "Test_APP_2023_B"
password     = "Test_APP_2023_B"

print(f"Connecting to '{db_schema:s}@{db_host:s}' with user '{db_user_name:s}'....", end="", flush=True)
mydb = mysql.connector.connect(
    host=db_host,
    database=db_schema,
    user=db_user_name,
    password=password,
    auth_plugin='mysql_native_password'
)
print("completed!")
print('\n\n')


stm_selectCities = """
    SELECT
       city_id    AS id,
       city       AS Name,
       country_id AS Country
    FROM 
       city
    WHERE 
       city like BINARY 'O%'
"""
print(stm_selectCities,end='\n\n\n')



print('mycursor_hash = mydb.cursor(dictionary=True)')
mycursor_hash = mydb.cursor(dictionary=True)
mycursor_hash.execute(stm_selectCities)
myresult_hash = mycursor_hash.fetchall()
print("Records found:", len(myresult_hash), myresult_hash)
print("+------+--------------------------------+------------+")
print("| Id   | City                           | Country ID |")
print("+------+--------------------------------+------------+")
for aRec in myresult_hash:
    print("| {plh:4d} |".format(plh=aRec['id']), end="")
    print(" {plh:30s} |".format(plh=aRec['Name']), end="")
    print(" {plh:10d} |".format(plh=aRec['Country']), end="")
    print()
    print("+------+--------------------------------+------------+")
