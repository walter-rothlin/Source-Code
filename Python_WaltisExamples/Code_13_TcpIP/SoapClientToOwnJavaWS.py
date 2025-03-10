#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: SoapClientToOwnJavaWS.py
#
# Description: Calls a WS witten in Java (JEE)
#              Glassfish must running on teachers node
#
# Autor: Walter Rothlin
#
# History:
# 12-Oct-2021   Walter Rothlin      Initial Version for BWI-A19
# ------------------------------------------------------------------
import zeep

# Client config using WSDL
client = zeep.Client(wsdl='http://10.192.100.97:8080/04_a_Webservice_Simple/FirstWebServiceService?wsdl')   # HWZ LAN
# client = zeep.Client(wsdl='http://desktop-nskdqsg:8080/04_a_Webservice_Simple/FirstWebServiceService?wsdl')

# Calling Web-Services and display result
print("Pin()              :", client.service.ping())
print('sayHelloName("HWZ"):', client.service.sayHelloName("HWZ"))
print('calcCircleArea(5)  :', client.service.calcCircleArea(5))
