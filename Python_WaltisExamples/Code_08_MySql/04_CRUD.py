#!/usr/bin/python3

from waltisLibrary import *
import sys
import mysql.connector

# https://www.w3schools.com/python/python_mysql_getstarted.asp
# https://pynative.com/python-mysql-execute-stored-procedure/   Calling stored procedure


print("Connecting to DB....", end="", flush=True)
mydb = mysql.connector.connect(
  host     = "localhost",
  user     = "root",
  passwd   = "admin"
)
print("completed!\n\n")


# Create schema
print("Create schema....", end="", flush=True)
mycursor = mydb.cursor()
mycursor.execute("DROP SCHEMA DelMe")
mycursor.execute("CREATE DATABASE DelMe")
mycursor.execute("USE DelMe")
print("completed!\n\n")

# check available schemas
print("Show schemas....", end="", flush=True)
mycursor.execute("SHOW DATABASES")
for x in mycursor:
  print(x)
print("completed!\n\n")


# create table
print("Create table....", end="", flush=True)
mycursor.execute("CREATE TABLE customers (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), address VARCHAR(255))")
# mycursor.execute("CREATE TABLE customers (name VARCHAR(255), address VARCHAR(255))")
print("completed!\n\n")

# check available tables
print("Show tables....", end="", flush=True)
mycursor.execute("SHOW TABLES")
for x in mycursor:
  print(x)
print("completed!\n\n")

# Insert data into table
print("Inserts data....\n", end="", flush=True)
sql = "INSERT INTO customers (name, address) VALUES (%s, %s)"
val = ("John", "Highway 21")
mycursor.execute(sql, val)
print("1 record inserted, ID:", mycursor.lastrowid)
print(mycursor.rowcount, "record inserted.")
mydb.commit()
print(mycursor.rowcount, "record inserted.")


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
halt("Commit?")
mydb.commit()
halt("After commit!")
print(mycursor.rowcount, "record inserted.")
print("completed!\n\n")

# Check data
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