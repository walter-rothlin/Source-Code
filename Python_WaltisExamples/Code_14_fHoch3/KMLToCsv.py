#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: KMLToCsv.py
#
# Description: Converts and XML (Export from Geo-Admin) to an csv File
#
#
# Autor: Walter Rothlin
#
# History:
# 07-Jul-2021   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
from lxml import etree
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


sourceFN = 'Kuessnacht.kml'
sourceNiceFN = 'Kuessnacht_nice.kml'
destinationFN = 'Kuessnacht.csv'

baseFor_KML = 'G:/_WaltisDaten/SourceCode/GitHosted/Python_WaltisExamples/Code_14_fHoch3/F_hoch_3/FDP_Plakate/'
baseFor_XSL = 'G:/_WaltisDaten/SourceCode/GitHosted/XML/'
baseFor_XSD = 'G:/_WaltisDaten/SourceCode/GitHosted/XML/'
baseFor_CSV = baseFor_KML


kmlFN = baseFor_KML + sourceFN
kmlNiceFN = baseFor_KML + sourceNiceFN
xsltFN = baseFor_XSL + 'transform_kml_csv.xsl'
csvFN = baseFor_CSV + destinationFN

# Fromating KML
# -------------
print("Formating:\n    ", kmlFN, "\n    ", kmlNiceFN)
root = ET.parse(kmlFN).getroot()
indent(root)
ET.dump(root)
treeStr = ET.ElementTree(root)
treeStr.write(kmlNiceFN)



# Transformation
# --------------
print('Reading XSLT:\n', xsltFN, '\n\n')
data = open(xsltFN)
xslt_content = data.read()
xslt_root = etree.XML(xslt_content)


print('reading KML:\n', kmlNiceFN, '\n\n')
dom = etree.parse(kmlNiceFN)

transform = etree.XSLT(xslt_root)
result = transform(dom)


print('writting csv:\n', csvFN, '\n\n')
f = open(csvFN, 'w')
f.write('# Konverted from KMLToCsv.py\n')
f.write(str(result))
f.close()
