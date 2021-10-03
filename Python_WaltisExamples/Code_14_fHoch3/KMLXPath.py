#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: KMLXPath.py
#
# Description: Accesses a XML Document via xPath
# https://riptutorial.com/python/example/29019/searching-the-xml-with-xpath
# https://docs.python.org/3/library/xml.etree.elementtree.html
#
# Autor: Walter Rothlin
#
# History:
# 03-Oct-2021   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
import xml.etree.cElementTree as ElT

tree = ElT.parse("G:/_WaltisDaten/SourceCode/GitHosted/XML/sample_3.xml")
root = tree.getroot()   # root = ET.fromstring(country_data_as_string)

print("1:", tree.findall('Books/Book'))
print("2:", tree.find("Books/Book[Title='The Colour of Magic']"))


print("3a:", tree.find("Books/Book[@id='5'].Title").text)
print("3b:", tree.find("Books/Book[@id='5'].Author").text)
book5 = tree.find("Books/Book[@id='5']")
print("3c:", book5.find("Title").text)
print("3d:", book5.find("Author").text)
## print("3e:", tree.find(string(Books/Book[@id=5]/@price))
## print("3e:", tree.xpath("Books/Book[@id='5']/price"))

print("4:", tree.find("Books/Book[2]"))
print("5:", tree.find("Books/Book[last()]"))
print("6:", tree.findall(".//Author"))
