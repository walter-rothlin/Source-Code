

# https://github.com/TobiasRothlin/SwissQRInvoiceGenerator

from SwissQRInvoiceGenerator import *


if __name__ == '__main__':
    addr_leer = {
        "name": "",
        "address": "",
        "zip_code": "",
        "city": "",
        "country": "",
    }

    addr_walti = {
        "name": "Walter Rothlin",
        "address": "Peterliwiese 33",
        "zip_code": "8855",
        "city": "Wangen SZ",
        "country": "CH",
    }

    addr_tobias = {
        "name": "Tobias Rothlin",
        "address": "Peterliwiese 33",
        "zip_code": "8855",
        "city": "Wangen SZ",
        "country": "CH",
    }

    addr_fw = {
        "name": "Feuerwehrverein",
        "address": " Wangen-Nuolen",
        "zip_code": "8855",
        "city": "Wangen SZ",
        "country": "CH",
    }

    ibanNr = {
        "raiffeisen_walti": "CH9580808006989422343",
        "csuh_walti":       "CH8704835041184041000",
        "cslachen_walti":   "CH3904835056306331000",
        "post_lohn_tobias": "CH6709000000303904208",
        "post_lohn_lukas":  "CH2709000000319272638",
        "post_spar_tobias": "CH1509000000922735753",
        "post_spar_lukas":  "CH6809000000924135382",
        "szkb_liegenschaft_remo": "CH9800777001683190170",
        "szkb_privat_remo": "CH28 0077 7001 6831 9007 2",
        "feuerwehr_wangen_oktoberfest": "CH41 0077 7005 8249 1145 5"
    }

    pdfName = "GeneratedInvoices/Test_Invoice_OnlyEZ"
    htmlName = "GeneratedInvoices/Test_Invoice_OnlyEZ.html"
    createQRInvoice(
        generateQRInvoiceData(
            ibanNr["post_lohn_tobias"],
            addr_tobias,
            addr_walti,
            amount="20.00",
            additional_information="Trinkgeld Genossengemeinde"),
        pdfName=pdfName,
        htmlName=htmlName)

    print("Produced following files:")
    print("    --> ", pdfName)
    print("    --> ", htmlName)


    pdfName = "GeneratedInvoices/Test_Invoice"
    htmlName = "GeneratedInvoices/Test_Invoice.html"
    createQRInvoice(
        generateQRInvoiceData(
            ibanNr["post_lohn_tobias"],
            addr_tobias,
            addr_walti,
            amount="20.00",
            additional_information="Trinkgeld Genossengemeinde"),
        invoice_text_html="",
        pdfName=pdfName,
        htmlName=htmlName)

    print("Produced following files:")
    print("    --> ", pdfName)
    print("    --> ", htmlName)


    pdfName = "GeneratedInvoices/NeuerEZ_Oktoberfest"
    htmlName = "GeneratedInvoices/NeuerEZ_Oktoberfest.html"
    createQRInvoice(
        generateQRInvoiceData(
            ibanNr["feuerwehr_wangen_oktoberfest"],
            addr_fw,
            addr_leer,
            amount="0.00",
            additional_information="Tickets: Ihre Nummer angeben!"),
        invoice_text_html="",
        pdfName=pdfName,
        htmlName=htmlName)

    print("Produced following files:")
    print("    --> ", pdfName)
    print("    --> ", htmlName)