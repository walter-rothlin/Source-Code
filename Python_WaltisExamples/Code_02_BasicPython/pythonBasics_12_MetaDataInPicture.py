# https://pillow.readthedocs.io/en/stable/reference/Image.html#examples    Bildverarbeitung
# http://metapicz.com/#landing  Web-Applikation zum Meta-Tags auslesen

from PIL import Image

img = Image.open('Vogt-7.JPG')
exif_data = img._getexif()
print(exif_data)



# JSON besser formatieren
for anEntryKey in exif_data:
    print(anEntryKey, "-->", exif_data[anEntryKey])


img.rotate(45).show()