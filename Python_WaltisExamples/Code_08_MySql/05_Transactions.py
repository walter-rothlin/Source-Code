#!/usr/bin/python3

from waltisLibrary import *
import sys
import mysql.connector

# https://pynative.com/python-mysql-transaction-management-using-commit-rollback/

try:
    conn = mysql.connector.connect(host='localhost',
                                   database='python_db',
                                   user='pynative',
                                   password='pynative@#29')

    conn.autocommit = False
    cursor = conn.cursor()
    # withdraw from account A
    sql_update_query = """Update account_A set balance = 1000 where id = 1"""
    cursor.execute(sql_update_query)

    # Deposit to account B
    sql_update_query = """Update account_B set balance = 1500 where id = 2"""
    cursor.execute(sql_update_query)
    print("Record Updated successfully ")

    # Commit your changes
    conn.commit()

except mysql.connector.Error as error:
    print("Failed to update record to database rollback: {}".format(error))
    # reverting changes because of exception
    conn.rollback()
finally:
    # closing database connection.
    if conn.is_connected():
        cursor.close()
        conn.close()
        print("connection is closed")