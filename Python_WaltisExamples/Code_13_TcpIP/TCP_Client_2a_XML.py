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
from waltisLibrary import *
from SocketDefinitions import *
import lxml.etree

doLoop = True
while doLoop:
    xml_file = lxml.etree.parse("serviceMsg.xml")
    xml_validator = lxml.etree.XMLSchema(file="serviceMsg.xsd")
    is_valid = xml_validator.validate(xml_file)
    print("XSD Validation:", is_valid)


    sendMsg = File_getFileContent("serviceMsg.xml")
    print("Received:", callService(msg=sendMsg))
    answer = input("Beenden?")
    if answer != "":
        doLoop = False
print(f"TCP/IP Client closed on '{PORT:d}'!")
