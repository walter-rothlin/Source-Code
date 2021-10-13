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

HOST = '127.0.0.1'  # The server's hostname or IP address
PORT = 65432        # The port used by the server

# client part
def callService(trace=False, msg=None):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        if trace:
            print(f"TCP/IP Client connecting to '{PORT:d}'...", end="", flush=True)
        s.connect((HOST, PORT))
        if trace:
            print("...connected!")
            print("--> ", msg)

        data = bytes(msg, 'ascii')
        s.sendall(data)

        data = s.recv(1024)  # 1024 is the maximum size of data in bytes
        strReceived = str(data, 'ascii')
        return strReceived
        if trace:
            print("<-- ", strReceived)

# server part
def waitForServiceCall(trace=True):
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
                    print("No more data received!!!")
                    break
                strReceived = str(data, 'ascii')
                strSent = serviceHandler(strReceived)

                data = bytes(strSent, 'ascii')
                if trace:
                    print("==> ", strSent)
                conn.sendall(data)

def serviceHandler(dataReceived, trace=True):
    strReceivedParts = dataReceived.split(":")
    fctName = strReceivedParts[0]
    fctParam = strReceivedParts[1]

    if trace:
        print("<== ", dataReceived)
        print("<== ", strReceivedParts)

    if fctName == "toUpper":
        dataSentBack = fctParam.upper()
    elif fctName == "toLower":
        dataSentBack = fctParam.lower()
    else:
        dataSentBack = "ERROR: Unknown Function"

    if trace:
        print("==> ", dataSentBack)

    return dataSentBack
