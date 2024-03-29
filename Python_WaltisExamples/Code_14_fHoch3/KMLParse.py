#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: KMLParse.py
#
# Description: Parses an XML Document
#
# Autor: Walter Rothlin
#
# History:
# 03-Oct-2021   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

from xml.dom import minidom

dom = minidom.parse("C:/Users/Landwirtschaft/Documents/SoruceCode/XML/sample_2.xml")

# doc.getElementsByTagName returns NodeList
name = dom.getElementsByTagName("name")[0]
print(name.firstChild.data)

staffs = dom.getElementsByTagName("staff")
print("+-----+----------------+----------------+")
print("|{id:5s}| {name:15s}| {sal:15s}|".format(id="id:", name="nickname:", sal="salary:"))
print("+-----+----------------+----------------+")
for staff in staffs:
        sid = staff.getAttribute("id")
        nickname = staff.getElementsByTagName("nickname")[0]
        salary = staff.getElementsByTagName("salary")[0]
        print("|{id:5s}| {name:15s}| {sal:15s}|".format(id=sid, name=nickname.firstChild.data, sal=salary.firstChild.data))
print("+-----+----------------+----------------+")


