#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: XML_Operations.py
#
# Description: reading, Manipulating and writing XML-document
#      https://docs.python.org/3/library/xml.etree.elementtree.html
#
# Autor: Walter Rothlin
#
# History:
# 14-Oct-2021   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
import xml.etree.ElementTree
import xml.etree.ElementTree as ET

# parsing xml from file
tree = ET.parse('country_data.xml')
root = tree.getroot()


xmlStr = '''<?xml version="1.0"?>
<data>
    <country name="Liechtenstein">
        <rank>1</rank>
        <year type="published">2008</year>
        <gdppc>141100</gdppc>
        <neighbor name="Austria" direction="E"/>
        <neighbor name="Switzerland" direction="W"/>
    </country>
    <country name="Singapore">
        <rank>4</rank>
        <year>2011</year>
        <gdppc>59900</gdppc>
        <neighbor name="Malaysia" direction="N"/>
    </country>
    <country name="Panama">
        <rank>68</rank>
        <year type="initiated" timezone="US">2011</year>
        <gdppc>13600</gdppc>
        <neighbor name="Costa Rica" direction="W"/>
        <neighbor name="Colombia" direction="E"/>
    </country>
</data>
'''

# parsing XML from string
## root = ET.fromstring(xmlStr)


# reading elements and attributes
print("\n\nReading elements and attributes from XML-Tree")
for country in root:
    print(country.tag, country.attrib, country[1].text)
    rank = country.find('rank').text   # getting value from tag element
    gdppc = country.find('gdppc').text
    year = country.find('year').text
    yearAttrType = country.find('year').get('type')
    yearAttr = country.find('year').attrib
    print("    rank :", rank, "\n    gdppc:", gdppc, "\n    year:", year, "\n    yearAttrType:", yearAttrType)
    print("    yearAttr:", yearAttr)

print()
for country in root.findall('country'):
    rank = country.find('rank').text   # getting value from tag element
    name = country.get('name')         # getting attribute value from name
    print(name, rank)

print("\n\nAccessing elements and attributes from XML-Tree by XPath")
thirdCountryYear = root.find("./country[3].year")
print("find(./country[3].year):", thirdCountryYear.text)
print("find(./country[3].year):", thirdCountryYear.attrib)
print("find(./country[3].year):", thirdCountryYear.get('type'), thirdCountryYear.get('timezone'))
print()
for countryYear in root.findall("./country/year"):
    print("findall(./country/year):", countryYear.text)
    print("findall(./country/year):", countryYear.attrib)
    print("findall(./country/year):", countryYear.get('type'), countryYear.get('timezone'))
    print()
print()

# changing elements and attributes
secondCountryYear = root.find("./country[2].year")
secondCountryYear.text = "1960"
secondCountryYear.attrib = {"Setter": "gugus", "timeZone": "UTC"}
print()

# tree to string
xmlStrOut = xml.etree.ElementTree.tostring(root)
print(xmlStrOut)

# saving xml directly into a file
tree.write('country_data_mod.xml')
