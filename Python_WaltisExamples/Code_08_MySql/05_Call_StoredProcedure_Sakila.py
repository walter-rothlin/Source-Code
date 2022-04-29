#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 05_Call_StoredProcedure_Sakila.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_08_MySql/05_Call_StoredProcedure_Sakila.py
#
# Description: Connects to sakila and calls stored procedures
# https://www.mysqltutorial.org/calling-mysql-stored-procedures-python/
#
#
# Autor: Walter Rothlin
#
# History:
# 18-Oct-2021   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
import mysql.connector as mc # mysql-connector-python not default mässiger one
import sys

'''
-- Create_Add_StoredProcedure.sql
-- ------------------------------

DELIMITER //

CREATE PROCEDURE add_num(IN num1 INT, IN num2 INT, OUT sum INT)
BEGIN
     SET sum := num1 + num2;
END 

CREATE PROCEDURE add_sub_num(IN num1 FLOAT, IN num2 FLOAT, OUT sum FLOAT, OUT diff FLOAT)
BEGIN
      SET sum  := num1 + num2;
      SET diff := num1 - num2;
END//

DELIMITER ;

'''
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
    conn = mc.connect(
        host=dbServer,
        database=dbSchema,
        user=userName,
        password=password,
        auth_plugin = 'mysql_native_password'
    )
    print("completed!")

    myCursor = conn.cursor()

    # calling add_num
    args = ("7", 6, 'x')      # 'x' in the Tuple will be replaced by OUT-Value
    result_args = myCursor.callproc('add_num', args)
    print("     args       :", args)
    print("     result_args:", result_args)
    print("add_num:", args[0], "+", args[1], "=", result_args[2])

    # calling add_sub_num
    args = ("7", 6.4, 'x', 'y')
    result_args = myCursor.callproc('add_sub_num', args)
    print("     args       :", args)
    print("     result_args:", result_args)
    print("add_sub_num:", args[0], "+", args[1], "=", result_args[2])
    print("add_sub_num:", args[0], "-", args[1], "=", result_args[3])


except mc.Error as e:
    print("\nError {errNo:d}: {errTxt:s}".format(errNo=e.args[0], errTxt=e.args[1]))
    sys.exit(1)

finally:
        myCursor.close()
        conn.close()
