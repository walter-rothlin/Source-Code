#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 02_SelectSakila.py
#
# Description: Connects to sakila and queries data
#
# Autor: Walter Rothlin
#
# History:
# 26-May-2020   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

import sys
import mysql.connector as mc # mysql-connector-python not default mässiger one


dbServer = "localhost"
dbSchema = "sakila"
userName = "testUserApp"
password = "walti"

connected = False
while not connected:
    try:
        print(f"Connecting to '{dbSchema:s}' with user '{userName:s}'....", end="", flush=True)
        # https://dev.mysql.com/doc/connector-python/en/connector-python-connectargs.html
        mydb = mc.connect(
            host=dbServer,
            database=dbSchema,
            user=userName,
            password=password,
            auth_plugin='mysql_native_password'
        )
        print("completed!")
        connected = True

    except mc.Error as e:
        print("\nError {errNo:d}: {errTxt:s}".format(errNo=e.args[0], errTxt=e.args[1]))
        sys.exit(1)


stm_selectCities = """
    SELECT
       ID,
       Name,
       Address
    FROM 
       customer_list
    WHERE
       name like 'JO%'
    ORDER BY name;
"""

mycursor = mydb.cursor()
mycursor.execute(stm_selectCities)
myresult = mycursor.fetchall()

print("Records found:", len(myresult), myresult)

print("+------+--------------------------------+--------------------------------+")
print("| Id   | Name                           | Adresse                        |")
print("+------+--------------------------------+--------------------------------+")
for aRec in myresult:
    print("| {plh:4d} |".format(plh=aRec[0]), end="")
    print(" {plh:30s} |".format(plh=aRec[1]), end="")
    print(" {plh:30s} |".format(plh=aRec[2]), end="")
    print()
    print("+------+--------------------------------+--------------------------------+")

