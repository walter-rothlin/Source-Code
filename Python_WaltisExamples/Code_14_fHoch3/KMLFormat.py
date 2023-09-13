#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: KMLToCsv.py
#
# Description: Formats a XML (Export from Geo-Admin) to an nice (indentation) XML document
#
#
# Autor: Walter Rothlin
#
# History:
# 03-Oct-2021   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
import xml.etree.ElementTree as ET


def indent(elem, level=0):
    i = "\n" + level * "  "
    j = "\n" + (level - 1) * "  "
    if len(elem):
        if not elem.text or not elem.text.strip():
            elem.text = i + "  "
        if not elem.tail or not elem.tail.strip():
            elem.tail = i
        for subelem in elem:
            indent(subelem, level + 1)
        if not elem.tail or not elem.tail.strip():
            elem.tail = j
    else:
        if level and (not elem.tail or not elem.tail.strip()):
            elem.tail = j
    return elem


root = ET.parse("../Code_14_fHoch3/F_hoch_3/FDP_Plakate/Neu_3.kml").getroot()
indent(root)

ET.dump(root)
treeStr = ET.ElementTree(root)
treeStr.write("../Code_14_fHoch3/F_hoch_3/FDP_Plakate/Neu_3_nice.kml")

