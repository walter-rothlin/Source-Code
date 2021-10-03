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

ortschaft = 'Kuessnacht_nice'
baseFor_XSL = 'G:/_WaltisDaten/SourceCode/GitHosted/XML/'
baseFor_KML = 'G:/_WaltisDaten/SourceCode/GitHosted/Python_WaltisExamples/Code_14_fHoch3/F_hoch_3/FDP_Plakate/'
baseFor_CSV = baseFor_KML

xsltFN = baseFor_XSL + 'transform_kml_csv.xsl'
print('reading XSLT:\n', xsltFN, '\n\n')
data = open(xsltFN)
xslt_content = data.read()
xslt_root = etree.XML(xslt_content)

kmlFN = baseFor_KML + ortschaft + '.kml'
print('reading KML:\n', kmlFN, '\n\n')
dom = etree.parse(kmlFN)

transform = etree.XSLT(xslt_root)
result = transform(dom)

csvFN = baseFor_CSV + ortschaft + '.csv'
print('writting csv:\n', csvFN, '\n\n')
f = open(csvFN, 'w')
f.write('# Konverted from hydrantenToCsv.py\n')
f.write(str(result))
f.close()
