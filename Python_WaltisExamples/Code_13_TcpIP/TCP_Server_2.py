#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: TCP_Server_2.py
# GIT: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_13_TcpIP/TCP_Server_2.py
#
# Description: Acts as an TCP/IP socket server
# https://realpython.com/python-sockets/
#
# Autor: Walter Rothlin
#
# History:
# 26-May-2020   Walter Rothlin      Initial Version
# 24-Sep-2021   Walter Rothlin      Git Test
# 12-Oct-2021   Walter Rothlin      XML-Msg
# 20-Sep-2022   Walter Rothlin      Changes for BWI-A20
# ------------------------------------------------------------------
from SocketDefinitions import *


print("\n")
print(f"TCP/IP Server ready on '{PORT:d}'. Waiting for requests....", end="", flush=True)
print(waitForServiceCall(xmlMsg=False, trace=True))
print(f"TCP/IP Server closed on '{PORT:d}'!")
