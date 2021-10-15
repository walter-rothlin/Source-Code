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


msgTemplate = "serviceMsgTemplate.xml"
messageFile = "serviceMsg.xml"
messageSchema = "serviceMsg.xsd"

doLoop = True
while doLoop:
    # Parameter vom Benutzer eingeben
    fctStr   = input("Fct [toUpper, toLower]:")
    fctParam = input("Text:")
    fctParamList = [fctParam]

    # Benutzerparameter in XML speichern
    prepareRequestMsg(msgTemplate=msgTemplate, msgFile=messageFile, fct=fctStr, parameterList=fctParamList)

    # XML validiern
    xml_file = lxml.etree.parse(messageFile)
    xml_validator = lxml.etree.XMLSchema(file=messageSchema)
    is_valid = xml_validator.validate(xml_file)

    if is_valid:
        # Nachricht (Request) senden und Antwort (Response) anzeigen
        sendMsg = File_getFileContent(messageFile)
        print("\n\n    Received at client:", callService(msg=sendMsg, trace=True))
    else:
        print("XML-Request is not valid document! Not sent to Server!")
    answer = input("Beenden?")
    if answer != "":
        doLoop = False
print(f"TCP/IP Client closed on '{PORT:d}'!")
