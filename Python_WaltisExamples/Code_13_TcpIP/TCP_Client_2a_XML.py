#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: TCP_Client_2.py
#
# Description: Acts as an TCP/IP socket server
# https://realpython.com/python-sockets/
#
# Autor: Walter Rothlin
#
# History:
# 26-May-2020   Walter Rothlin      Initial Version
# 12-Oct-2021   Walter Rothlin      XML-Msg
# ------------------------------------------------------------------
from SocketDefinitions import *

doLoop = True
while doLoop:
    fctStr   = input("Fct :")
    fctParam = input("Text:")
    sendMsg = fctStr + ":" + fctParam
    print("Received:", callService(msg=sendMsg))
    answer = input("Beenden?")
    if answer != "":
        doLoop = False
print(f"TCP/IP Client closed on '{PORT:d}'!")
