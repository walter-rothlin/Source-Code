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
# ------------------------------------------------------------------

# Install driver first: python -m pip install mysql-connector-python



import mysql.connector

dbServer = "localhost"
dbSchema = "sakila"
userName = "APP_User_Banken"
password = "awc-07!"

print(f"Connecting to '{dbSchema:s}' with user '{userName:s}'....", end="", flush=True)
mydb = mysql.connector.connect(
    host=dbServer,
    database=dbSchema,
    user=userName,
    password=password,
    auth_plugin = 'mysql_native_password'
)
print("completed!")
