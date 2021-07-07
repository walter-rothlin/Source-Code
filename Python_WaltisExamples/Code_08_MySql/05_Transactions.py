#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 05_Transactions.py
#
# Description: Connects to MyBank and demonstrates a transaction (Kontoübertrag)
#
#              Use the following sql-script to create MyBank schema:
#              https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Datenbanken/Scripts/Create_Bankkonto.sql
#
# Autor: Walter Rothlin
#
# History:
# 26-May-2020   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
from waltisLibrary import *
import mysql.connector

# https://pynative.com/python-mysql-transaction-management-using-commit-rollback/

def showSaldo(title="", titleLevel=1):

    if titleLevel == 1:
        uChar = "="
        abstand = "\n"
    elif titleLevel == 2:
        uChar = "-"
        abstand = ""

    print(unterstreichen(title, uChar), abstand)
    # zeige Konto Saldos and Bilanzsumme
    sql_show_saldo_query = """
    select id_bankkonto, saldo from bankkonto;
    """
    cursor.execute(sql_show_saldo_query)
    myresult = cursor.fetchall()
    print("+------+--------------+")
    print("| Id   | Saldo        |")
    print("+------+--------------+")
    bilanzsumme = 0
    for aRec in myresult:
        bilanzsumme += aRec[1]
        print("| {id:4d} |".format(id=aRec[0]), end="")
        print(" {saldo:12.2f} |".format(saldo=aRec[1]), end="")
        print()
    print("+------+--------------+")
    print("| Summe: {summe:12.2f} |".format(summe=bilanzsumme))
    print("+------+--------------+")
    print("Records found:", len(myresult), myresult)


dbServer = "localhost"
dbSchema = "MyBank"
userName = "root"
password = "admin"

try:
    print(f"Connecting to '{dbSchema:s}' with user '{userName:s}'....", end="", flush=True)
    # https://dev.mysql.com/doc/connector-python/en/connector-python-connectargs.html
    conn = mysql.connector.connect(
        host=dbServer,
        database=dbSchema,
        user=userName,
        passwd=password
    )
    print("completed!")

    conn.autocommit = False
    cursor = conn.cursor()

    showSaldo("Bevor Kontoübertrag")

    # withdraw from Lohnkonto
    withdrawAmount = readFloat("Betrag: ", min=10, max=10000)
    sql_update_query = """Update bankkonto set saldo = saldo - """ + str(withdrawAmount) + """ where id_bankkonto = 1"""
    cursor.execute(sql_update_query)

    showSaldo("Abgebucht aber noch nicht eingebucht", 2)
    halt("Check with workebnch!! Than press RETURN to continue!")


    # deposit to Sparkonto
    sql_update_query = """Update bankkonto set saldo = saldo + """ + str(withdrawAmount) + """ where id_bankkonto = 2"""
    cursor.execute(sql_update_query)
    print("Record Updated successfully...", end="", flush=True)

    # Commit your changes
    conn.commit()
    print("and commited!")

    showSaldo("Nach Kontoübertrag")

except mysql.connector.Error as error:
    print("Failed to update record to database rollback: {}".format(error))
    # reverting changes because of exception
    conn.rollback()
finally:
    # closing database connection.
    if conn.is_connected():
        cursor.close()
        conn.close()
        print("Connection is closed")
