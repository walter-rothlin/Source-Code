#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: SocketDefinitions.py
#
# Description: Global values for the socket examles
#
# Autor: Walter Rothlin
#
# History:
# 12-Oct-2021   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
import socket
import xml.etree.ElementTree as ET

HOST = '127.0.0.1'  # The server's hostname or IP address
PORT = 65432        # The port used by the server

msgTemplate   = "serviceMsgTemplate.xml"
messageSchema = "serviceMsgTemplate.xsd"

# client functions
# ----------------
def callService(msg, trace=False):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        if trace:
            print(f"TCP/IP Client connecting to '{PORT:d}'...", end="", flush=True)
        s.connect((HOST, PORT))
        if trace:
            print("...connected!")
            print("\n--> Request sent from client:\n", msg)

        data = bytes(msg, 'ascii')
        s.sendall(data)

        data = s.recv(1024)  # 1024 is the maximum size of data in bytes
        strReceived = str(data, 'ascii')
        if trace:
            print("\n<-- Response client received:\n", strReceived)

        return strReceived

# server functions
# ----------------
def waitForServiceCall(xmlMsg=True, trace=True):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind((HOST, PORT))
        s.listen()
        while True:
            conn, addr = s.accept()
            while True:
                if trace:
                    print(f"Server reads data from '{PORT:d}'..")
                data = conn.recv(1024)  # 1024 is the maximum size of data in bytes
                if not data:
                    # print("No more data received!!!")
                    break
                requestMsg = str(data, 'ascii')

                if trace:
                    print("\nServer received :\n", requestMsg, "\n")

                if xmlMsg:
                    responseMsg = serviceHandlerXML(requestMsg, trace=trace)
                else:
                    responseMsg = serviceHandlerCsv(requestMsg, trace=trace)

                data = bytes(responseMsg, 'ascii')
                if trace:
                    print("\nServer sent back:\n", responseMsg, "\n")
                conn.sendall(data)

def serviceHandlerCsv(request, trace=True):
    strReceivedParts = request.split(":")
    fctName = strReceivedParts[0]
    fctParam = strReceivedParts[1]
    if trace:
        print("<== ", request)
        print("<== ", strReceivedParts)
    if fctName == "toUpper":
        response = fctParam.upper()
    elif fctName == "toLower":
        response = fctParam.lower()
    else:
        response = "ERROR: Unknown Function-String:\n" + request
    if trace:
        print("==> ", response)
    return response

def serviceHandlerXML(request, trace=True):
    # reading values from XML-Request
    root = ET.fromstring(request)
    secondCountryYear = root.find("./function")
    fct = secondCountryYear.text
    parameterList = []
    for aParam in root.findall("./*/param"):
        parameterList.append(aParam.text)

    if trace:
        print("\nfctStr       :", fct)
        print("\nparameterList:", parameterList)

    # Business-Logic
    if fct == "toUpper":
        response = parameterList[0].upper()
    elif fct == "toLower":
        response = parameterList[0].lower()
    else:
        response = "ERROR: Unknown Function-String:\n" + request

    return response

def prepareRequestMsg(msgTemplate, msgFile, fct, parameterList):
    # parsing msgTemplate and replaces values with user input
    tree = ET.parse(msgTemplate)
    root = tree.getroot()
    secondCountryYear = root.find("./function")
    secondCountryYear.text = fct
    i = 0
    for aParam in root.findall("./*/param"):
        if (i < len(parameterList)):
            aParam.text = parameterList[i]
        else:
            aParam.text = "NotUsed"
        i += 1

    # save msg in file
    tree.write(msgFile)
