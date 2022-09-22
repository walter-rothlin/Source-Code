#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: TCP_Server_2a_XML.py
# GIT: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_13_TcpIP/TCP_Server_2a_XML.py
#
# Description: Acts as an TCP/IP socket server
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

print(f"TCP/IP Server ready on '{PORT:d}'. Waiting for requests....")
print(waitForServiceCall(xmlMsg=True, trace=True))
print(f"TCP/IP Server closed on '{PORT:d}'!")
