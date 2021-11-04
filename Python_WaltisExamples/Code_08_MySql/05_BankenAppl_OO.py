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
# 31-Oct-2021   Walter Rothlin      fixed hardcoded Bilanzsummen Berechnung
# ------------------------------------------------------------------
from waltisLibrary import *
import mysql.connector

class Konto:
    def __init__(self, id, saldo, limite=0):
        self.__id = id
        self.__saldo = saldo
        self.__limite = limite

    def __str__(self):
        return "id: {id:6d}    saldo: {saldo:10.2f}    limite: {limite:10.2f}".format(id=self.__id, saldo=self.__saldo, limite=self.__limite)

    def toString(self, part="main", bilanzsumme=0):
        retStr = ""
        if part == "title":
            retStr += "+--------+------------+------------+\n"
            retStr += "| {id:6s} | {saldo:10s} | {limite:10s} |\n".format(id="ID", saldo="Saldo", limite="Limite")
            retStr += "+--------+------------+------------+\n"
        if part == "main":
            retStr += "| {id:6d} | {saldo:10.2f} | {limite:10.2f} |\n".format(id=self.__id, saldo=self.__saldo, limite=self.__limite)
        if part == "footer":
            retStr += "+--------+------------+------------+\n"
            retStr += "| Summe: {summe:12.2f} |            |\n".format(summe=bilanzsumme)
            retStr += "+--------+------------+------------+\n"
        return retStr

    def setSaldo(self, newSaldo):
        self.__saldo = newSaldo

    def getSaldo(self):
        return self.__saldo

    def getId(self):
        return self.__id

    # returns effektiver Bezug
    def bezug(self, amount):
        if self.__saldo - amount >= self.__limite:
            self.__saldo -= amount
            return amount
        else:
            alterSaldo = self.__saldo
            self.__saldo = self.__limite
            return alterSaldo - self.__limite

    # returns neuer Kontostand
    def deposit(self, amount):
        self.__saldo += amount
        return self.__saldo

def Test_Konto():
    print("\n")
    print(unterstreichen("Test-Konto"))
    sparkonto = Konto(1, 2000, 100)
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
    def __init__(self, owner="Unknown"):
        self.__owner = owner
        self.__kontoList = {}

    def __str__(self):
        retStr = "owner: " + str(self.__owner) + "\n"
        for aKontoKey in self.__kontoList:
            retStr += "    " + str(self.__kontoList[aKontoKey]) + "\n"
        return retStr

    def addKonto(self, newKonto):
        self.__kontoList[newKonto.getId()] = newKonto

    def getKontoViaID(self, id):
        return self.__kontoList[id]

    def showKontoUebersicht(self):
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

    def getBilanzSumme(self):
        bilanzSumme = 0
        for aKontoKey in self.__kontoList:
            aKonto = self.__kontoList[aKontoKey]
            bilanzSumme += aKonto.getSaldo()
        return bilanzSumme

    def doKontoUebertrag(self, withdrawAmount, fromKontoId, toKontoId, trace=True):
        withdrawAmount = self.getKontoViaID(fromKontoId).bezug(withdrawAmount)
        self.getKontoViaID(toKontoId).deposit(withdrawAmount)


def Test_Kontoliste():
    print("\n")
    print(unterstreichen("Test-Kontoliste"))
    waltisKonties = Kontoliste("Walter Rothlin")
    waltisKonties.addKonto(Konto(1, 10000))
    waltisKonties.addKonto(Konto(2, 2000, limite=-100))
    # print(waltisKonties)
    waltisKonties.showKontoUebersicht()
    print("\n--> transfer from 1 to 2: 1111")
    waltisKonties.doKontoUebertrag(1111, 1, 2)
    waltisKonties.showKontoUebersicht()
    print("\n--> transfer from 2 to 1: 4000")
    waltisKonties.doKontoUebertrag(4000, 2, 1)
    waltisKonties.showKontoUebersicht()


if __name__ == '__main__':
    if True:
        Test_Kontoliste()

# ----------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------