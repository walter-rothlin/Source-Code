# http://metapicz.com/#landing  Web-Applikation zum Meta-Tags auslesen

import PIL.Image

img = PIL.Image.open('Vogt-7.JPG')
exif_data = img._getexif()
print(exif_data)



