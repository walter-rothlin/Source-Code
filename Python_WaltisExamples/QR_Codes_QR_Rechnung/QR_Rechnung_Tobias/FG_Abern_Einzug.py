#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: FG_Abern_Einzug.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamplesQR_Codes_QR_Rechnung/QR_Rechnung_Tobias/FG_Abern_Einzug.py
#
# Description: Produces QR-Rechnungen for Flurgenossenschaft Abern
#
# Autor: Walter Rothlin
#
# History:
# 17-Jun_2022   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
from SwissQRInvoiceGenerator import *
from openpyxl import load_workbook
from waltisLibrary import *


if __name__ == '__main__':
    addr_FG_Aberen = {
        "name": "Flurgenossenschaft",
        "address": "'Aberen'",
        "zip_code": "8858",
        "city": "Innerthal",
        "country": "",
    }

    ibanNr = {
        "FG_Abern": "CH90 0077 7003 2922 1166 7"
    }



    # Load in the workbook
    wb = load_workbook('N:\\06_FG_Abern\\FG_Aberen_Kassier.xlsx')
    print(wb.sheetnames)
    dataSheet = wb['Perimeter']

    doLoop = True
    row = 2
    while doLoop:
        aVal = dataSheet['A' + str(row)].value
        print(dataSheet['L' + str(row)].value)
        if aVal is not None:
            addr_kreditor = {
                "name": aVal + " " + dataSheet['B' + str(row)].value,
                "address": dataSheet['C' + str(row)].value,
                "zip_code": "",
                "city": dataSheet['D' + str(row)].value,
                "country": "",
            }
            print(aVal)
            pdfName = "GeneratedInvoices/FG_Aberen_" + str(row)
            htmlName = "GeneratedInvoices/FG_Aberen" + str(row) + ".html"
            createQRInvoice(
                generateQRInvoiceData(
                    ibanNr["FG_Abern"],
                    addr_FG_Aberen,
                    addr_kreditor,
                    amount="10.00",     # dataSheet['L' + str(row)].value,
                    additional_information="FG Abern: "),
                invoice_text_html="",
                pdfName=pdfName,
                htmlName=htmlName)

            print("Produced following files:")
            print("    --> ", pdfName)
            print("    --> ", htmlName)

            row += 1
        else:
            doLoop = False









