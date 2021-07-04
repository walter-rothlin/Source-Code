#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 04a_CRUD_Sakila.py
#
# Description: Connects to sakila and queries data
#
# Autor: Walter Rothlin
#
# History:
# 26-May-2020   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

from waltisLibrary import *
import mysql.connector as mc # mysql-connector-python not default mässiger one
import sys


def showTable():
    print("+------+--------------------------------+")
    print("| Id   | Country                        |")
    print("+------+--------------------------------+")
    for aRec in myResult:
        print("| {plh:4d} |".format(plh=aRec[0]), end="")
        print(" {plh:30s} |".format(plh=aRec[1]), end="")
        print()
        print("+------+--------------------------------+")
    print("Records found:", len(myResult), myResult)


# =============================
# MAIN
# =============================
dbServer = "localhost"
dbSchema = "sakila"
userName = "root"
password = "admin"

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


# MAIN
# -----------------------------

stm_selectCities = """
    SELECT
       country_id    AS ID,
       country       AS Name
    FROM 
       country
    ORDER BY
       country_id
"""

myCursor = mydb.cursor()
myCursor.execute(stm_selectCities)
myResult = myCursor.fetchall()
showTable()
halt()

# single insert
sql = "INSERT INTO country (country) VALUES (%s)"
val = ("John")
myCursor = mydb.cursor()
myCursor.execute(sql, val)
showTable()
halt()
