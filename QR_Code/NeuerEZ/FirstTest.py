

# https://github.com/TobiasRothlin/SwissQRInvoiceGenerator

from SwissQRInvoiceGenerator import *


if __name__ == '__main__':
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

    ibanNr = {
        "raiffeisen_walti": "CH9580808006989422343",
        "csuh_walti":       "CH8704835041184041000",
        "cslachen_walti":   "CH3904835056306331000",
        "post_lohn_tobias": "CH6709000000303904208",
        "post_lohn_lukas":  "CH2709000000319272638",
        "post_spar_tobias": "CH1509000000922735753",
        "post_spar_lukas":  "CH6809000000924135382",
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