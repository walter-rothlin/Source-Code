#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 05_BankenAppl_OO.py
#
# Description: Implements Kontoübertrag (OO-Lösung)
#
#              Use the following sql-script to create MyBank schema:
#              https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Datenbanken/Scripts/Create_Bankkonto.sql
#
# Autor: Walter Rothlin
#
# History:
# 20-Oct-2021   Walter Rothlin      Initial Version
# 21-Oct-2021   Walter Rothlin      Added persistence layer
# ------------------------------------------------------------------
from waltisLibrary import *
import mysql.connector

class Konto:
    def __init__(self, id, saldo, limite=0, kontoArt="Unknown", owner="Unknown", dbCon=None, dbCursor=None):
        self.__id = id
        self.__saldo = saldo
        self.__limite = limite
        self.__kontoArt = kontoArt
        self.__owner = owner
        self.__conn = dbCon
        self.__cursor = dbCursor

    def __str__(self):
        return "id: {id:6d}    saldo: {saldo:10.2f}    limite: {limite:10.2f}    kontoArt: {kArt:20s}    owner: {owner:30s}".format(id=self.__id, saldo=self.__saldo, limite=self.__limite, kArt=self.__kontoArt, owner=self.__owner)

    def toString(self, part="main", bilanzsumme=0):
        retStr = ""
        if part == "title":
            retStr += "+--------+------------+------------+----------------------+--------------------------------+\n"
            retStr += "| {id:6s} | {saldo:10s} | {limite:10s} | {kArt:20s} | {owner:30s} |\n".format(id="ID", saldo="Saldo", limite="Limite", kArt="Konto-Art", owner="Owner")
            retStr += "+--------+------------+------------+----------------------+--------------------------------+\n"
        if part == "main":
            retStr += "| {id:6d} | {saldo:10.2f} | {limite:10.2f} | {kArt:20s} | {owner:30s} |\n".format(id=self.__id, saldo=self.__saldo, limite=self.__limite, kArt=self.__kontoArt, owner=self.__owner)
        if part == "footer":
            retStr += "+--------+------------+------------+----------------------+--------------------------------+\n"
            retStr += "| Summe: {summe:12.2f} |            |                      |                                |\n".format(summe=bilanzsumme)
            retStr += "+--------+------------+------------+----------------------+--------------------------------+\n"
        return retStr

    def setSaldo(self, newSaldo, doCommit = True):
        self.__saldo = newSaldo
        if self.__cursor is not None:
            sql_update_query = """Update bankkonto set saldo = """ + str(newSaldo) + """ where id_bankkonto = """ + str(self.__id)
            self.__cursor.execute(sql_update_query)
            if doCommit:
                self.__conn.commit()

    def getSaldo(self):
        return self.__saldo

    def getId(self):
        return self.__id

    # returns effektiver Bezug
    def bezug(self, amount, doCommit = True):
        effBezug = 0
        if self.__saldo - amount >= self.__limite:
            self.__saldo -= amount
            effBezug = amount
        else:
            alterSaldo = self.__saldo
            self.__saldo = self.__limite
            effBezug = alterSaldo - self.__limite

        if self.__cursor is not None:
            sql_update_query = """Update bankkonto set saldo = saldo - """ + str(effBezug) + """ where id_bankkonto = """ + str(self.__id)
            self.__cursor.execute(sql_update_query)
            if doCommit:
                self.__conn.commit()
        return effBezug

    # returns neuer Kontostand
    def deposit(self, amount, doCommit = True):
        self.__saldo += amount

        if self.__cursor is not None:
            sql_update_query = """Update bankkonto set saldo = saldo + """ + str(amount) + """ where id_bankkonto = """ + str(self.__id)
            self.__cursor.execute(sql_update_query)
            if doCommit:
                self.__conn.commit()

        return self.__saldo

def Test_Konto():
    print("\n")
    print(unterstreichen("Test-Konto"))
    sparkonto = Konto(1, 2000, 100, "Testkonto", "Test-Person")
    print(sparkonto, "\n")
    print("Bezug:   100:", sparkonto.bezug(100))
    print(sparkonto, "\n")
    print("Bezug:  2000:", sparkonto.bezug(2000))
    print(sparkonto, "\n")
    print("Einlage: 550:", sparkonto.deposit(550))
    print(sparkonto, "\n")

if __name__ == '__main__':
    if False:
        Test_Konto()


# ----------------------------------------------------------------------
class Kontoliste:
    def __init__(self, owner="Unknown", dbServer = "localhost", dbSchema = "MyBank", userName = "root", password = "admin"):
        self.__owner = owner
        self.__kontoList = {}
        self.__dbServer = dbServer
        self.__dbSchema = dbSchema
        self.__userName = userName
        self.__password = password

        print(f"Connecting to '{dbSchema:s}' with user '{userName:s}'....", end="", flush=True)
        # https://dev.mysql.com/doc/connector-python/en/connector-python-connectargs.html
        self.__conn = mysql.connector.connect(
            host=self.__dbServer,
            database=self.__dbSchema,
            user=self.__userName,
            passwd=self.__password
        )
        print("completed!")
        self.__conn.autocommit = False   # explicit commit and rollback by the application (Front-End)
        self.__cursor = self.__conn.cursor()

        # load kontoliste from DB
        sql_show_saldo_query = """
             select 
                  id_bankkonto, 
                  saldo,
                  limite,
                  kontoArt,
                  owner
            from bankkonto
            where owner = '""" + self.__owner + """';
        """
        self.__cursor.execute(sql_show_saldo_query)
        myresult = self.__cursor.fetchall()
        for aRec in myresult:
            # print("| {id:4d} | {saldo:10.2f} |".format(id=aRec[0], saldo=aRec[1]))
            self.addKonto(Konto(id=aRec[0], saldo=aRec[1], limite=aRec[2], kontoArt=aRec[3], owner=aRec[4], dbCon=self.__conn, dbCursor=self.__cursor))


    def __str__(self):
        retStr = "owner: " + str(self.__owner) + "\n"
        for aKontoKey in self.__kontoList:
            retStr += "    " + str(self.__kontoList[aKontoKey]) + "\n"
        return retStr

    def addKonto(self, newKonto):
        self.__kontoList[newKonto.getId()] = newKonto

    def getKontoViaID(self, id):
        return self.__kontoList[id]

    def showKontoUebersicht(self, title=None):
        if title is not None:
            print("\n\n--->" + title)
        print(unterstreichen("Kontoübersicht von " + str(self.__owner)))
        firstTime = True
        aKonto = None
        for aKontoKey in self.__kontoList:
            aKonto = self.__kontoList[aKontoKey]
            if firstTime:
                firstTime = False
                print(aKonto.toString("title"), end="")
            print(aKonto.toString(), end="")
        bilanzSumme = self.getBilanzSumme()
        print(aKonto.toString("footer", bilanzSumme), end="")

    def doKontoUebertrag(self, withdrawAmount, fromKontoId, toKontoId, trace=True):
        try:
            effWithDraw = self.getKontoViaID(fromKontoId).bezug(withdrawAmount, False)
            self.getKontoViaID(toKontoId).deposit(effWithDraw, False)
            self.__conn.commit()
        except:
            self.__conn.rollback()

    def getBilanzSumme(self):
        bilanzSumme = 0
        for aKontoKey in self.__kontoList:
            aKonto = self.__kontoList[aKontoKey]
            bilanzSumme += aKonto.getSaldo()
        return bilanzSumme

def Test_Kontoliste():
    print("\n")
    print(unterstreichen("Test-Kontoliste"))
    waltisKonties = Kontoliste("Walter Rothlin")
    # print(waltisKonties)
    waltisKonties.showKontoUebersicht(title="Nach Initialisierung (lesen von DB)")

    # Test Konto-Classe
    print("\n ---> Test Konto")
    kontoWalti_1 = waltisKonties.getKontoViaID(1)
    print(kontoWalti_1)
    kontoWalti_1.setSaldo(2345)
    print("Bezug   2000:", kontoWalti_1.bezug(2000))
    print("Bezug   2000:", kontoWalti_1.bezug(2000))
    print("Deposit 2000:", kontoWalti_1.deposit(2000))

    kontoWalti_2 = waltisKonties.getKontoViaID(2)
    print(kontoWalti_2)
    kontoWalti_2.setSaldo(10234)
    waltisKonties.showKontoUebersicht(title="Nach manuellem Konto setzen")

    # Test Kontouebertrag
    print("\n ---> Test Kontoübertrag")
    fromKonto = readInt("Belastungskonto (From): ", min=1, max=2)
    toKonto   = readInt("Gutschriftskonto (To) : ", min=1, max=2)
    transferAmount = readFloat("Uebertrags-Betrag: ", min=10, max=10000)

    waltisKonties.doKontoUebertrag(transferAmount, fromKonto, toKonto)
    waltisKonties.showKontoUebersicht(title=" After: {fff:3d} --> {tAm:1.2f} --> {ttt:3d}".format(fff=fromKonto, ttt=toKonto, tAm=transferAmount))

    waltisKonties.doKontoUebertrag(transferAmount, toKonto, fromKonto)
    waltisKonties.showKontoUebersicht(title=" After: {ttt:3d} --> {tAm:1.2f} --> {fff:3d}".format(fff=fromKonto, ttt=toKonto, tAm=transferAmount))

    # Set back to original amounts
    kontoWalti_1.setSaldo(2000)
    kontoWalti_2.setSaldo(5000)
    waltisKonties.showKontoUebersicht(title="After set back to original amounts")

if __name__ == '__main__':
    if True:
        Test_Kontoliste()

# ----------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------