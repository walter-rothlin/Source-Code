#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: TCP_Server_2.py
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
# ------------------------------------------------------------------
from SocketDefinitions import *

print(f"TCP/IP Server ready on '{PORT:d}'. Waiting for requests....")
print(waitForServiceCall(xmlMsg=True, trace=True))
print(f"TCP/IP Server closed on '{PORT:d}'!")
