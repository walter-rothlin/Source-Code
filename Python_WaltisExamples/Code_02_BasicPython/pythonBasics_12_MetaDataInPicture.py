# http://metapicz.com/#landing  Web-applikation zum Meta-Tags auslesen

import PIL.Image
img = PIL.Image.open('Vogt-7.JPG')
exif_data = img._getexif()

for anEntryKey in exif_data:
    print(anEntryKey, "-->", exif_data[anEntryKey])

print(exif_data)
