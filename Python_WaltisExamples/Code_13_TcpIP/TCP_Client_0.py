#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: TCP_Client_0.py
# GIT: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_13_TcpIP/TCP_Client_0.py
#
# Description: Acts as an TCP/IP socket server
#
# Autor: Walter Rothlin
#
# History:
# 26-May-2020   Walter Rothlin      Initial Version
# 20-Sep-2022   Walter Rothlin      Changes for BWI-A20
# 11-Mar-2025   Walter Rothlin      Changes for BWI-A22
#
# ------------------------------------------------------------------

import socket
# https://realpython.com/python-sockets/

HOST = '127.0.0.1'  # The server's hostname or IP address
PORT = 1025        # The port used by the server

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    print(f"TCP/IP Client connecting to '{PORT:d}'...", end="", flush=True)
    s.connect((HOST, PORT))
    print("...connected!")

    ## sendText = b'Hello, world'
    sendText = input("Text:")
    data = bytes(sendText, 'ascii')

    print("--> ", sendText)
    s.sendall(data)

    data = s.recv(1024)  # 1024 is the maximum size of data in bytes
    strReceived = str(data, 'ascii')
    print("<-- ", strReceived)

print(f"TCP/IP Client closed on '{PORT:d}'!")
