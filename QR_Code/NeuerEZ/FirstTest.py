

# https://github.com/TobiasRothlin/SwissQRInvoiceGenerator

from SwissQRInvoiceGenerator import *


if __name__ == '__main__':
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
        "amount": "5.00",
        "currency": "CHF",
        "reference_type": "QRR",
        "reference_number": "210000000003139471430009017",
        "additional_information": "Test123",
    }
    createQRInvoice(data)
