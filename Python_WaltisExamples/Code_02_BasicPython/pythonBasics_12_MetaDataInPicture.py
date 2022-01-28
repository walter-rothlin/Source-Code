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
# Auf Windows mit File-Explorer Properties --> Details
#
# History:
# 22.4.21   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
from PIL import Image
from time import sleep


img = Image.open('Bilder/Vogt-7.JPG')
# img = Image.open('Bilder/Bruch_1.jpg')
# img = Image.open('Bilder/Screenshot.png')

exif_data = img._getexif()
print("Meta-Data", exif_data)

if exif_data is not None:
    for anEntryKey in exif_data:
        print(anEntryKey, "-->", exif_data[anEntryKey])
for angle in range(1, 45, 10):
    img.rotate(angle).show()
    sleep(0.5)
