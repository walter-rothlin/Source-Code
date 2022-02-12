#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 04_CRUD.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_08_MySql/04_CRUD.py
#
# Description: Connects to mysql and creates a new schema, Inserts, Updates and Inserts Data
#
# https://www.w3schools.com/python/python_mysql_getstarted.asp
# Autor: Walter Rothlin
#
# History:
# 26-May-2020   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

from waltisLibrary import *
import mysql.connector


print("Connecting to DB....", end="", flush=True)
mydb = mysql.connector.connect(
  host        = "localhost",
  user        = "root",
  password    = "admin",
  auth_plugin = 'mysql_native_password'
)
print("completed!\n\n")

# DDL: Create schema
print("Create schema....", end="", flush=True)
mycursor = mydb.cursor()
mycursor.execute("DROP SCHEMA IF EXISTS DelMe")
mycursor.execute("CREATE DATABASE DelMe")
mycursor.execute("USE DelMe")
print("completed!\n\n")
halt()

# DDL: Check available schemas
print("Show schemas....", end="", flush=True)
mycursor.execute("SHOW DATABASES")
for aSchema in mycursor:
  print(aSchema)
print("completed!\n\n")
halt()

# DDL: Create table
print("Create table....", end="", flush=True)
mycursor.execute("CREATE TABLE customers (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), address VARCHAR(255))")
# mycursor.execute("CREATE TABLE customers (name VARCHAR(255), address VARCHAR(255))")
print("completed!\n\n")

# DDL: Check available tables
print("Show tables....", end="", flush=True)
mycursor.execute("SHOW TABLES")
for aTable in mycursor:
  print(aTable)
print("completed!\n\n")

# DML: Insert data into table
print("Inserts data....")
sql = "INSERT INTO customers (name, address) VALUES (%s, %s)"
val = ("John", "Highway 21")
mycursor.execute(sql, val)
print("A single record inserted ", val, " , ID:", mycursor.lastrowid)
print(mycursor.rowcount, "record inserted.")
mydb.commit()
print(mycursor.rowcount, "record inserted.\n")

# DML: Update data from table
print("Update data....")
updateSQL = f"  UPDATE customers SET name='Walti' WHERE id=1"
print(updateSQL, "\n\n")
mycursor.execute(updateSQL)
halt("Update commit?")
mydb.commit()
halt("After commit?")

# DML: Delete data from table
print("Delete data....")
deleteSQL = f"  Delete from customers WHERE id=1"
print(deleteSQL, "\n\n")
mycursor.execute(deleteSQL)
halt("Delete commit?")
mydb.commit()
halt("After commit?")

print("Bulk load ... insert")
sql = "INSERT INTO customers (name, address) VALUES (%s, %s)"
val = [
  ('Peter', 'Lowstreet 4'),
  ('Amy', 'Apple st 652'),
  ('Hannah', 'Mountain 21'),
  ('Michael', 'Valley 345'),
  ('Sandy', 'Ocean blvd 2'),
  ('Betty', 'Green Grass 1'),
  ('Richard', 'Sky st 331'),
  ('Susan', 'One way 98'),
  ('Vicky', 'Yellow Garden 2'),
  ('Ben', 'Park Lane 38'),
  ('William', 'Central st 954'),
  ('Chuck', 'Main Road 989'),
  ('Viola', 'Sideway 1633')
]
mycursor.executemany(sql, val)
print(mycursor.rowcount, "record inserted.")
halt("Bulkload commit?")
mydb.commit()
halt("After bulkload commit!")
print(mycursor.rowcount, "record inserted.")
print("completed!\n\n")

# DML: Check data
print("Show data...\n", end="", flush=True)
print(mycursor.rowcount, "record inserted.")
stm_selectCities = """
    SELECT
       * 
    FROM 
       customers
"""
mycursor.execute(stm_selectCities)
myresult = mycursor.fetchall()
print("Records found:", len(myresult), myresult)
print("completed!\n\n")
