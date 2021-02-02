# importing the requests library
import requests
import json

# defining the api-endpoint
ApiEndpoint = "https://kmuqr.quickapps.mx/api/exampleQrFree"

# defining pdf getter
pdfGetterBase = 'https://kmuqr.quickapps.mx/api/downloadFree?fileName='

# defining header
headers = {
    'POST': '/api/exampleQrFree HTTP/1.1',
    'Host': 'kmuqr.quickapps.mx',
    'Connection': 'keep-alive',
    'Origin': 'https://kmuqr.quickapps.mx',
    'Referer': 'https://kmuqr.quickapps.mx/create-qr'
}

# data to be sent to api
sprache = "de"
additionalInfo = ""
mitteilung = "Ist mal ein Test mit einer selbst erstellten QR-Rechnung von Claudia"
waehrung = "CHF"
betrag = 20
betragStr = "{b:1.2f}".format(b=betrag)
reference = ""

for_firstname = "Walter"
for_name = "Rothlin"
for_street = "Peterliwiese"
for_no = 33
for_plz = "8855"
for_city = "Wangen SZ"
for_iban = "CH3904835056306331000"
for_country = for_iban[0:2]

from_firstname = "Remo"
from_name = "Collet Rothlin"
from_street = "Peakplace"
from_no = 55
from_plz = "8000"
from_city = "Laax GR"
from_country = "CH"

data = {
    "UID": "",
    "language": sprache,
    "AdditionalInformationString": additionalInfo,
    "unstructuredMessage": mitteilung,
    "currency": waehrung,
    "amount": betrag,
    "reference": reference,
    "creditor": {
        "name": for_firstname,
        "last_name": for_name,
        "address": for_street + " " + str(for_no),
        "street": for_street,
        "number": for_no,
        "zip": for_plz,
        "city": for_city,
        "account": for_iban,
        "country": for_country
    },
    "debitor": {
        "name": from_firstname,
        "last_name": from_name,
        "address": from_street + " " + str(from_no),
        "street": from_street,
        "number": from_no,
        "zip": from_plz,
        "city": from_city,
        "country": from_country
    },
    "additionalInformation": {
        "VAT_Date": {
            "start_date": None,
            "end_date": None
        },
        "VAT_Details": [],
        "VAT_Import": [],
        "VAT_Conditions": []
    }
}


# sending post request and saving response as response object
r = requests.post(url=ApiEndpoint, json=data, headers=headers)

# extracting response text
pastebin_url = r.text

ezResponse = json.loads(pastebin_url)
pdfFilePath = pdfGetterBase + ezResponse['file']
print(pdfGetterBase + ezResponse['file'])
pdfResponse = requests.get(pdfGetterBase + ezResponse['file'])
with open('Gen_EZ.pdf', 'wb') as f:
    f.write(pdfResponse.content)

# print(ezResponse["qrSvg"])
svgQRPath = ezResponse["qrSvg"].split("\n")[0]
print("svgPath:", svgQRPath)

svgHeader = """<?xml version='1.0' encoding='UTF-8'?>"""

qrCodeSvg = """<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" data-v-223f4b97="" version="1.2" width="210mm" height="110mm">
   <svg width="46mm" height="46mm" x="67mm" y="22mm">""" + svgQRPath + """ 
      <svg width="7mm" height="7mm" x="20mm" y="20mm" viewBox="0 0 19.8 19.8">
         <polygon points="18.3,0.7 1.6,0.7 0.7,0.7 0.7,1.6 0.7,18.3 0.7,19.1 1.6,19.1 18.3,19.1 19.1,19.1 19.1,18.3 19.1,1.6 19.1,0.7 " fill="black" />
         <rect x="8.3" y="4" width="3.3" height="11" fill="white" />
         <rect x="4.4" y="7.9" width="11" height="3.3" fill="white" />
         <polygon points="0.7,1.6 0.7,18.3 0.7,19.1 1.6,19.1 18.3,19.1 19.1,19.1 19.1,18.3 19.1,1.6 19.1,0.7 18.3,0.7 1.6,0.7 0.7,0.7 " fill="none" stroke="white" stroke-width="1.4357" stroke-miterlimit="10" />
      </svg>
   </svg>
</svg>
"""

schere = '✂'
ezSVG = '''<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" data-v-223f4b97="" version="1.2" width="210mm" height="110mm">
   <line y1="5mm" y2="5mm" x1="0mm" x2="210mm" stroke="black" height="0.5mm" stroke-dasharray="5,5" d="M5 20 l215 0" />
   <text x="25mm" y="5mm" text-anchor="middle" style="transform: rotate(45deg) rotate(-41.8deg); transform-origin: 0% 0%;">xx</text>
   <line x1="62mm" x2="62mm" y1="5mm" y2="110mm" stroke="black" height="0.5mm" stroke-dasharray="5,5" d="M5 20 l215 0" />
   <text x="3mm" y="50mm" text-anchor="middle" style="transform: rotate(45deg) rotate(-136.5deg); transform-origin: 21% 28.9%;">xx</text>
   <svg x="5mm" y="10mm" width="52mm" height="63mm">
      <text dy="5mm" class="title-r/p">Empfangsschein</text>
      <text y="9mm" x="0mm">
         <tspan x="0mm" dy="18pt" class="heading-r">Konto / Zahlbar an</tspan>
         <tspan x="0mm" dy="16pt" class="value-r" />
         <tspan x="0mm" dy="11pt" class="value-r" />
         <tspan x="0mm" dy="11pt" class="value-r">
            <tspan x="0mm" dy="8pt" class="value-r" />
         </tspan>
         <tspan x="0mm" dy="11pt" class="value-r" />
         <tspan x="0mm" dy="13pt" class="value-r" />
         <tspan x="0mm" dy="11pt" class="value-r">
            <tspan x="0mm" dy="8pt" class="value-r" />
         </tspan>
      </text>
   </svg>
   <text x="5mm" y="48mm" class="heading-r">Zahlbar durch (Name/Adresse)</text>
   <svg version="1.1" id="Ebene_1" x="5mm" y="50mm">
      <g>
         <g>
            <rect x="0" width="3mm" height="0.75pt" />
         </g>
         <g>
            <rect width="0.75pt" height="3mm" />
         </g>
      </g>
      <g>
         <g>
            <rect x="0" y="20mm" width="3mm" height="0.75pt" />
         </g>
         <g>
            <rect y="17mm" width="0.75pt" height="3mm" />
         </g>
      </g>
      <g>
         <g>
            <rect x="49.25mm" width="3mm" height="0.75pt" />
         </g>
         <g>
            <rect x="52mm" y="0" width="0.75pt" height="3mm" />
         </g>
      </g>
      <g>
         <g>
            <rect x="49.25mm" y="20mm" width="3mm" height="0.75pt" />
         </g>
         <g>
            <rect x="52mm" y="17mm" width="0.75pt" height="3mm" />
         </g>
      </g>
   </svg>
   <svg id="amount-section" y="80mm" x="5mm" width="52mm" height="14mm">
      <text x="0mm" dy="15pt">
         <tspan x="0mm" dy="9pt" class="heading-r">Wahrung</tspan>
         <tspan x="0mm" dy="9pt" class="value-p">''' + waehrung + '''</tspan>
      </text>
      <text x="0mm" y="9pt">
         <tspan x="21.5mm" dy="0pt" class="heading-r">Betrag</tspan>
         <tspan x="21.5mm" dy="9pt" class="value-p">''' + betragStr + '''</tspan>
      </text>
   </svg>
   <svg id="acceptance" y="95mm" x="5mm" width="52mm" height="18mm">
      <text y="3mm" x="33mm" class="acceptance-point">Annahmestelle</text>
   </svg>
   <svg x="67mm" y="10mm" width="46mm" height="95mm">
      <text dy="5mm" class="title-r/p">Zahlteil</text>
   </svg>
   <svg width="46mm" height="46mm" x="67mm" y="22mm">
      <g>
         <rect width="46mm" height="46mm" style="fill: rgb(250, 250, 250);" />
      </g>
   </svg>''' + qrCodeSvg + '''
   <svg x="67mm" y="73mm" width="46mm" height="22mm">
      <text>
         <tspan x="0mm" dy="9pt" class="heading-p">Wahrung</tspan>
         <tspan x="0mm" dy="13pt" class="amount-p">''' + waehrung + '''</tspan>
      </text>
      <text>
         <tspan x="20mm" dy="9pt" class="heading-p">Betrag</tspan>
         <tspan x="20mm" dy="13pt" class="amount-p">''' + betragStr + '''</tspan>
      </text>
   </svg>
   <svg x="118mm" y="10mm" width="87mm" height="85mm">
      <text y="5mm" x="0mm" class="information-section">
         <tspan x="0mm" dy="0pt" class="is-heading-p">Konto / Zahlbar an</tspan>
         <tspan x="0mm" dy="16pt" class="is-value-p" />
         <tspan x="0mm" dy="11pt" class="is-value-p">
            <tspan x="0mm" dy="11pt" class="is-value-p" />
         </tspan>
         <tspan x="0mm" dy="11pt" class="is-value-p">
            <tspan x="0mm" dy="11pt" class="is-value-p" />
         </tspan>
         <textarea x="0mm" dy="11pt">asdfoasifjoasjdfjoasidjfoajsdof</textarea>
         <tspan x="0mm" dy="11pt" class="is-value-p" />
         <tspan x="0mm" dy="11pt" class="is-value-p" />
         <tspan x="0mm" dy="11pt" class="is-value-p" />
         <tspan x="0mm" dy="16pt" class="is-value-p">
            <tspan x="0mm" dy="11pt" class="is-value-p" />
         </tspan>
         <tspan x="0mm" dy="11pt" class="is-value-p">
            <tspan x="0mm" dy="11pt" class="is-value-p" />
         </tspan>
      </text>
   </svg>
   <text x="118mm" y="63mm" class="is-subtitle-p">Zahlbar durch (Name/Adresse)</text>
   <svg version="1.1" id="Ebene_1" x="118mm" y="65mm">
      <g>
         <g>
            <rect x="0" width="3mm" height="0.75pt" />
         </g>
         <g>
            <rect width="0.75pt" height="3mm" />
         </g>
      </g>
      <g>
         <g>
            <rect x="0" y="25mm" width="3mm" height="0.75pt" />
         </g>
         <g>
            <rect y="22mm" width="0.75pt" height="3mm" />
         </g>
      </g>
      <g>
         <g>
            <rect x="62.25mm" width="3mm" height="0.75pt" />
         </g>
         <g>
            <rect x="65mm" y="0" width="0.75pt" height="3mm" />
         </g>
      </g>
      <g>
         <g>
            <rect x="62.25mm" y="25mm" width="3mm" height="0.75pt" />
         </g>
         <g>
            <rect x="65mm" y="22mm" width="0.75pt" height="3mm" />
         </g>
      </g>
   </svg>
</svg>
'''

with open('../../QR_Code/QR_Rechnung/Gen_EZ.pdf', 'wb') as f:
    f.write(pdfResponse.content)

f = open("../../QR_Code/QR_Rechnung/Gen_QR.svg", "w")
f.write(qrCodeSvg)
f.close()

f = open("../../QR_Code/QR_Rechnung/Gen_EZ.svg", "w")
f.write(ezSVG)
f.close()

with open('Gen_EZ.pdf', 'wb') as f:
    f.write(pdfResponse.content)

f = open("Gen_QR.svg", "w")
f.write(qrCodeSvg)
f.close()

f = open("Gen_EZ.svg", "w")
f.write(ezSVG)
f.close()
