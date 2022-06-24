#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Stammdaten_Manager.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_08_MySql/Stammdaten_Manager.py
#
# Description: Manager für Stammdaten
#
# Autor: Walter Rothlin
#
# History:
# 24-Jun-2022   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
import mysql.connector

print("Connecting to Stammdaten-Schema....", end="", flush=True)
stammdaten_schema = mysql.connector.connect(
  host        = "localhost",
  user        = "App_User_Stammdaten",
  password    = "1234ABCD12abcd",
  database    = "stammdaten",
  auth_plugin = 'mysql_native_password'
)
print("completed!")

sql_stm_selectCountries = """
    SELECT
       id            AS ID,
       Name          AS Name,
       Code          AS Code,
       Landesvorwahl AS Landesvorwahl,
       DATE_FORMAT(last_update, '%Y%m%d_%H%i%s')   AS Last_Update
    FROM 
       Land
"""

mycursor = stammdaten_schema.cursor(dictionary=True)
mycursor.execute(sql_stm_selectCountries)
myresult = mycursor.fetchall()

print("Records found:", len(myresult), myresult, myresult[0])
for aRec in myresult:
  print(aRec['ID'], aRec['Last_Update'])






