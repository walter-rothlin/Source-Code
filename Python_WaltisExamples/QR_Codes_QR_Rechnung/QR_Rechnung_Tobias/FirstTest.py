#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: FirstTest.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_Waltis/ExamplesQR_Codes_QR_Rechnung/QR_Rechnung_Tobias/FirstTest.py
#
# Description: Produces QR-Rechnungen using Library from Tobias
#              https://github.com/TobiasRothlin/SwissQRInvoiceGenerator
#
# Autor: Walter Rothlin
#
# History:
# 17-Jun_2022   Walter Rothlin      Initial Version
# 31-Dec-2022   Walter Rothlin      Neuste Library: https://github.com/TobiasRothlin/SwissQRInvoiceGenerator
# 21-Dec-2023   Walter Rothlin      Modified for latest version of library
# ------------------------------------------------------------------
from waltisLibrary import *
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

    addr_FG_Aberen = {
        "name": "Flurgenossenschaft",
        "address": "'Aberen'",
        "zip_code": "8858",
        "city": "Innerthal",
        "country": "",
    }

    ibanNr = {
        "raiffeisen_walti": "CH9580808006989422343",
        "csuh_walti":       "CH8704835041184041000",
        "cslachen_walti":   "CH3904835056306331000",
        "post_lohn_tobias": "CH6709000000303904208",
        "post_lohn_lukas":  "CH2709000000319272638",
        "post_spar_tobias": "CH15 0900 0000 9227 3575 3",
        "post_spar_lukas":  "CH6809000000924135382",
        "szkb_liegenschaft_remo": "CH98 0077 7001 6831 9017 0",
        "szkb_privat_remo": "CH28 0077 7001 6831 9007 2",
        "feuerwehr_wangen_oktoberfest": "CH41 0077 7005 8249 1145 5",
        "FG_Abern": "CH90 0077 7003 2922 1166 7",
        "Sabine_Marty": "CH95 0873 1001 5681 2203 4"
    }

    pdfName = "GeneratedInvoices/FG_Aberen"
    htmlName = "GeneratedInvoices/FG_Aberen.html"
    createQRInvoice(
        generateQRInvoiceData(
            ibanNr["FG_Abern"],
            addr_FG_Aberen,
            addr_leer,
            amount="0.00",
            additional_information=""),
        invoice_text_html="",
        pdfName=pdfName,
        htmlName=htmlName)

    print("Produced following files:")
    print("    --> ", pdfName)
    print("    --> ", htmlName)


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
