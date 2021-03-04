
# QR-Rechnungen Validator: https://www.swiss-qr-invoice.org/validator/?lang=de

import qrcode
from PIL import Image

qr = qrcode.QRCode(
    version=1,
    error_correction=qrcode.constants.ERROR_CORRECT_L,
    box_size=10,
    border=4,
)

#Qr-Code Data
sprache = "de"
additionalInfo = ""
mitteilung = "Ist mal ein Test mit einer selbst erstellten QR-Rechnung von Claudia"
waehrung = "CHF"
betrag = 1
betragStr = "{b:1.2f}".format(b=betrag)
referenceType = "NON"
reference = "" #210000000003139471430009017

recipient_firstname = "Tobias"
recipient_name = " Rothlin"
recipient_street = "Peterliwiese"
recipient_no = 33
recipient_plz = "8855"
recipient_city = "Wangen SZ"
recipient_iban = "CH6209000000318538494"
recipient_country = recipient_iban[0:2]



from_firstname = "Walter"
from_name = " Rothlin"
from_street = "Peterliwiese"
from_no = 33
from_plz = "8855"
from_city = "Wangen SZ"
from_country = "CH"




qr.add_data(
    """SPC
0200
1
""" + recipient_iban + """
S
""" + recipient_firstname +  recipient_name + "\n" +
recipient_street + "\n" +
str(recipient_no) + "\n" +
recipient_plz + "\n" +
recipient_city + "\n" +
recipient_country + "\n" +
"""






""" + betragStr + "\n" +
waehrung + "\n" +
"S" + "\n" +
from_firstname + from_name + "\n" +
from_street + "\n" +
str(from_no) + "\n" +
from_plz + "\n" +
from_city + "\n" +
from_country + "\n" +
referenceType + "\n" +
reference + "\n"  +
mitteilung +"""
EPD"""
            )

qr.make(fit=True)

img = qr.make_image(fill_color="black", back_color="white")
Flag = Image.open("./Flag_small.jpg")
QrWidth, QrHeight = img.size
FlagWidth, FlagHeight = Flag.size

XFlagPos = int(QrWidth/2 - FlagWidth/2)
YFlagPos = int(QrHeight/2 - FlagHeight/2)
img.paste(Flag, (XFlagPos, YFlagPos))
img.save("./QRCode.png", "PNG")

