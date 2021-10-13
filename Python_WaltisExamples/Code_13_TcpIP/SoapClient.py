#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: SoapClient.py
#
# Description: Configures a client by an WSDL and calls a method passing two parameters
# https://docs.python-zeep.org/en/master/
#
# Autor: Walter Rothlin
#
# History:
# 12-Oct-2021   Walter Rothlin      Initial Version for BWI-A19
# ------------------------------------------------------------------
import zeep

# Client config using WSDL
client = zeep.Client(wsdl='http://www.soapclient.com/xml/soapresponder.wsdl')

# Calling an Soap Web-Service and display result
print(client.service.Method1('Zeep', 'is cool'))
