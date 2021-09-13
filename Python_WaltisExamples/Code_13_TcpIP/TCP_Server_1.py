#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: TCP_Server_1.py
#
# Description: Acts as an TCP/IP socket server
#
# Autor: Walter Rothlin
#
# History:
# 26-May-2020   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

import socket
# https://realpython.com/python-sockets/

HOST = '127.0.0.1'  # Standard loopback interface address (localhost)
PORT = 65432        # Port to listen on (non-privileged ports are > 1023)

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind((HOST, PORT))
    s.listen()
    while True:
        print("\n")
        print(f"TCP/IP Server ready on '{PORT:d}'. Waiting for requests....", end="", flush=True)
        conn, addr = s.accept()
        print("...received")
        with conn:
            while True:
                print(f"Server reads data from '{PORT:d}'..")
                data = conn.recv(1024)  # 1024 is the maximum size of data in bytes
                if not data:
                    print("No more data received!")
                    break
                strReceived = str(data, 'ascii')
                strReceivedParts = strReceived.split(":")
                fctName = strReceivedParts[0]
                fctParam = strReceivedParts[1]

                print("<== ", strReceived)
                print("<== ", strReceivedParts)

                if fctName == "toUpper":
                    strSent = fctParam.upper()
                elif fctName == "toLower":
                    strSent = fctParam.lower()
                else:
                    strSent = "ERROR: Unknown Function"
                data = bytes(strSent, 'ascii')
                print("==> ", strSent)
                conn.sendall(data)

print(f"TCP/IP Server closed on '{PORT:d}'!")
