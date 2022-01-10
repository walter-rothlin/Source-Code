#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 03_SelectSakila.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_08_MySql/03_SelectSakila.py
#
# Description: Connects to sakila and queries data
#
# Autor: Walter Rothlin
#
# History:
# 26-May-2020   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

import mysql.connector as mc # mysql-connector-python not default mässiger one
import sys
import json

dbServer = "localhost"
dbSchema = "sakila"
userName = "testUserApp"
password = "walti"

try:
    print(f"Connecting to '{dbSchema:s}' with user '{userName:s}'....", end="", flush=True)
    # https://dev.mysql.com/doc/connector-python/en/connector-python-connectargs.html
    mydb = mc.connect(
        host=dbServer,
        database=dbSchema,
        user=userName,
        passwd=password
    )
    print("completed!")

except mc.Error as e:
    print("\nError {errNo:d}: {errTxt:s}".format(errNo=e.args[0], errTxt=e.args[1]))
    sys.exit(1)


stm_selectCities = """
    SELECT
       JSON_OBJECT(
            'ID', ID,
            'Name', name,
            'Adresse', address
        ) AS JSON_RS
    FROM 
       customer_list
    WHERE
       name like 'JO%'
    ORDER BY name;
"""

myCursor = mydb.cursor()
myCursor.execute(stm_selectCities)
myresult = myCursor.fetchall()

print("Records found:", len(myresult), myresult)

print("+------+--------------------------------+--------------------------------+")
print("| Id   | Name                           | Adresse                        |")
print("+------+--------------------------------+--------------------------------+")
for aRec in myresult:
    aRecJSON = json.loads(str(aRec[0]))
    print("| {plh:4d} |".format(plh=aRecJSON['ID'])    , end="")
    print(" {plh:30s} |".format(plh=aRecJSON['Name'])   , end="")
    print(" {plh:30s} |".format(plh=aRecJSON['Adresse']), end="")
    print()
    print("+------+--------------------------------+--------------------------------+")
