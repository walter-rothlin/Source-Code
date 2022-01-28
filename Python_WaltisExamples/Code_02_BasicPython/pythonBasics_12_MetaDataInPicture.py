#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_12_MetaDataInPicture.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_12_MetaDataInPicture.py
#
# Description: Lädt ein Bild und liesst alle Meta-Tags
#
# Autor: Walter Rothlin
#
# https://pillow.readthedocs.io/en/stable/reference/Image.html#examples    Bildverarbeitung
# http://metapicz.com/#landing  Web-Applikation zum Meta-Tags auslesen
#
# History:
# 22.4.21   Walter Rothlin      Initial Version
# ------------------------------------------------------------------


from PIL import Image

img = Image.open('Vogt-7.JPG')
exif_data = img._getexif()
print(exif_data)


for anEntryKey in exif_data:
    print(anEntryKey, "-->", exif_data[anEntryKey])

img.rotate(45).show()
