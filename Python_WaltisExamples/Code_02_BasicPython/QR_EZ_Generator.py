# importing the requests library
import requests

# defining the api-endpoint
API_ENDPOINT = "https://kmuqr.quickapps.mx/api/exampleQrFree"

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
cred_name="Rothlin"

data = {
    "UID": "",
    "language": "de",
    "AdditionalInformationString":"",
    "unstructuredMessage": "Ist mal ein Test mit einer selbst erstellten QR-Rechnung von Tobias",
    "currency": "CHF",
    "amount": 1,
    "reference": "",
    "creditor": {
        "name": "Walter",
        "last_name": cred_name,
        "address": "Peterliwiese 33",
        "street": "Peterliwiese",
        "number": 33,
        "zip": "8855",
        "city": "Wangen",
        "account": "CH3904835056306331000",
        "country": "CH"
    },
    "debitor": {
        "name": "Claudia",
        "last_name":"Collet Rothlin",
        "address":"Peterliwiese 33",
        "street":"Peterliwiese",
        "number":"33",
        "zip":"8855",
        "city":"Wangen","country":"CH"},"additionalInformation":{"VAT_Date":{"start_date":None,"end_date":None},"VAT_Details":[],"VAT_Import":[],"VAT_Conditions":[]}}


# sending post request and saving response as response object
r = requests.post(url=API_ENDPOINT, json=data, headers=headers)

# extracting response text
pastebin_url = r.text
print(pastebin_url)
