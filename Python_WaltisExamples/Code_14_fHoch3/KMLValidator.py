#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: KMLValidator.py
#
# Description: Validates a XML document against XMLSchema, or DTD
# https://www.kite.com/python/answers/how-to-validate-an-xml-file-with-an-xml-schema-in-python
#
# Autor: Walter Rothlin
#
# History:
# 03-Oct-2021   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
import lxml.etree

xml_file = lxml.etree.parse("G:/_WaltisDaten/SourceCode/GitHosted/XML/sample_1.xml")
xml_validator = lxml.etree.XMLSchema(file="G:/_WaltisDaten/SourceCode/GitHosted/XML/sample_1.xsd")
is_valid = xml_validator.validate(xml_file)
print("XSD Validation:", is_valid)


xml_validator = lxml.etree.DTD(file="G:/_WaltisDaten/SourceCode/GitHosted/XML/sample_1.dtd")
is_valid = xml_validator.validate(xml_file)
print("DTD Validation:", is_valid)


xml_file = lxml.etree.parse("G:/_WaltisDaten/SourceCode/GitHosted/Python_WaltisExamples/Code_14_fHoch3/F_hoch_3/FDP_Plakate/Kuessnacht_nice.kml")
xml_validator = lxml.etree.XMLSchema(file="G:/_WaltisDaten/SourceCode/GitHosted/XML/kml.xsd")
is_valid = xml_validator.validate(xml_file)
print("KML Validation:", is_valid)
