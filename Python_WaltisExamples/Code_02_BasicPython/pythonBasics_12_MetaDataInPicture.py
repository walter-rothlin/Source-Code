# http://metapicz.com/#landing  Web-Applikation zum Meta-Tags auslesen


import PIL.Image

img = PIL.Image.open('Vogt-7.JPG')
exif_data = img._getexif()
print(exif_data)









# JSON besser formatieren
for anEntryKey in exif_data:
    print(anEntryKey, "-->", exif_data[anEntryKey])


