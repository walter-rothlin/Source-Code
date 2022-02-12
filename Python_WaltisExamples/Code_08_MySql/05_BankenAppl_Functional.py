#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 05_BankenAppl_Functional.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_08_MySql/05_BankenAppl_Functional.py
#
# Description: Implements Kontoübertrag (Lösung mit Functions)
#
#              Use the following sql-script to create MyBank schema:
#              https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Datenbanken/Scripts/Create_Bankkonto.sql
#
# Autor: Walter Rothlin
#
# History:
# 20-Oct-2021   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
from waltisLibrary import *
import mysql.connector


def showKontoUebersicht(connection, cursor, title="", titleLevel=1):

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


def doKontoUebertrag(connection, cursor, withdrawAmount, fromKontoId, toKontoId, trace=True):
    if trace:
        showKontoUebersicht(connection, cursor, "Bevor Kontoübertrag")

    # withdraw from Lohnkonto
    sql_update_query = """Update bankkonto set saldo = saldo - """ + str(withdrawAmount) + """ where id_bankkonto = """ + str(fromKontoId)
    cursor.execute(sql_update_query)

    if trace:
        showKontoUebersicht(connection, cursor, "Abgebucht aber noch nicht eingebucht", 2)
        halt("Check with workbench!! Than press RETURN to continue!")

    # deposit to Sparkonto
    sql_update_query = """Update bankkonto set saldo = saldo + """ + str(withdrawAmount) + """ where id_bankkonto = """ + str(toKontoId)
    cursor.execute(sql_update_query)

    if trace:
        showKontoUebersicht(connection, cursor, "Eingebucht aber noch nicht commited", 2)
        halt("Check with workbench!! Than press RETURN to continue!")

    # Commit your changes
    connection.commit()
    if trace:
        showKontoUebersicht(connection, cursor, "Nach commited", 2)
        halt("Check with workbench!! Than press RETURN to continue!")


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
        password=password,
        auth_plugin = 'mysql_native_password'
    )
    print("completed!")

    conn.autocommit = False   # explicit commit and rollback by the application (Front-End)
    cursor = conn.cursor()

    showKontoUebersicht(conn, cursor, "Vor Kontoübertrag")
    fromKonto = readInt("Belastungskonto (From): ", min=1, max=2)
    toKonto   = readInt("Gutschriftskonto (To) : ", min=1, max=2)
    withdrawAmount = readFloat("Uebertrags-Betrag: ", min=10, max=10000)

    doKontoUebertrag(conn, cursor, withdrawAmount, fromKontoId=fromKonto, toKontoId=toKonto, trace=False)

    showKontoUebersicht(conn, cursor, "Nach Kontoübertrag")


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
