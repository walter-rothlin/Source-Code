#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : 01_NeuerEZ_QR_Code.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/QR_Code/QR_Rechnung/01_NeuerEZ_QR_Code
#
# Description: Generates the QR-Code for a new Einzahlungsschein
#
#
# Autor: Walter Rothlin
#
# History:
# 03-Jan-2022   Walter Rothlin      Initial Version
#
# ------------------------------------------------------------------
import io

import qrcode
import qrcode.image.svg


def create_qr_code(json):
    qr_data = "SPC\n" \
              "0200\n" \
              "1\n" \
              + json["creditor_iban"] \
              + "\nK\n" \
              + json["creditor_name"] + "\n" \
              + json["creditor_address"] + "\n" \
              + json["creditor_zip_code"] + " " + json["creditor_city"] + "\n" \
              + "\n\n" \
              + json["creditor_country"] \
              + "\n\n\n\n\n\n\n\n" \
              + json["amount"] + "\n" \
              + json["currency"] + "\n" \
              + "K\n" \
              + json["debtor_name"] + "\n" \
              + json["debtor_address"] + "\n" \
              + json["debtor_zip_code"] + " " + json["debtor_city"] + "\n" \
              + "\n\n" \
              + json["debtor_country"] + "\n" \
              + json["reference_type"] + "\n" \
              + json["reference_number"] + "\n" \
              + json["additional_information"] + "\n" \
              + "EPD"

    img = qrcode.make(qr_data, image_factory=qrcode.image.svg.SvgImage)
    buffered = io.BytesIO()
    img.save(buffered, "SVG")

    xml_str = buffered.getvalue().decode("utf-8")

    closing_tag_pos = xml_str.rfind("</svg>")

    if closing_tag_pos >= 0:
        swiss_cross = """
        <rect x="25.9mm" y="25.9mm" class="st0" width="9.2mm" height="9.2mm"/>
        <rect x="27.5mm" y="27.5mm" width="6mm" height="6mm"/>
        <rect x="28.5mm" y="30mm" class="st0" width="4mm" height="1mm"/>
        <rect x="30mm" y="28.5mm" class="st0" width="1mm" height="4mm"/>
        <style type="text/css">.st0{fill:#FFFFFF;}</style>
        """

        xml_str = xml_str[:closing_tag_pos] + swiss_cross + xml_str[closing_tag_pos:]

    return xml_str

data = {
    "creditor_iban": "CH4000777003656120095",
    "creditor_name": "Tobias Rothlin",
    "creditor_address": "Peterliwiese 33",
    "creditor_zip_code": "8855",
    "creditor_city": "Wangen SZ",
    "creditor_country": "CH",
    "debtor_name": "Hans Muster",
    "debtor_address": "Sonnenstrasse 31",
    "debtor_zip_code": "2000",
    "debtor_city": "Schöningen",
    "debtor_country": "CH",
    "amount": "5000.00",
    "currency": "CHF",
    "reference_type": "SCOR",
    "reference_number": "test123",
    "additional_information": "Test123",
}

fileAsString = create_qr_code(data)
f = open("NewEZ_Examples/01_NewEZ_QrCode.svg", "w")
f.write(fileAsString)
f.close()
print('Neuer EZ QR Code:', 'NewEZ_Examples/01_NewEZ_QrCode.svg')
