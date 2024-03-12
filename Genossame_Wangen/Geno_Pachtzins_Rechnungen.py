#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Geno_Pachtzins_Rechnungen.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamplesQR_Codes_QR_Rechnung/QR_Rechnung_Tobias/Geno_Pachtzins_Rechnungen.py
#
# Description: Produces QR-Rechnungen for Genossame Wangen für Pachlandeinzug
#
# Autor: Walter Rothlin
#
# History:
# 17-Jun_2022   Walter Rothlin      Initial Version
# 31-Dec-2022   Walter Rothlin      Neuste Library: https://github.com/TobiasRothlin/SwissQRInvoiceGenerator

# ------------------------------------------------------------------
from SwissQRInvoiceGenerator import *
from Genossame_Common_Defs import *


if __name__ == '__main__':
    base_directory = './Rechnungen_2023/'
    base_directory = 'V:/Landwirtschaft/Pachtland/Pachtzinsrechnungen/2023/'


    title = 'Pachtlandzins_2024'

    geno_schema = db_connect(connect_to_prod=True, trace=True)
    ret_value = get_record_details_from_db(geno_schema, 'personen_daten', 625, ['ID', 'Firma', 'Private_Strassen_Adresse', 'Priv_PLZ', 'Priv_Ort', 'IBAN'], as_json=True, take_action=True, verbal=False)[0]

    rechnungs_steller = {
        "IBAN"    : ret_value['IBAN'],
        "name"    : ret_value['Firma'],
        "address" : ret_value['Private_Strassen_Adresse'],
        "zip_code": ret_value['Priv_PLZ'],
        "city"    : ret_value['Priv_Ort'],
        "country" : '',
    }

    print(rechnungs_steller)
    exit

    ret_values = get_record_details_from_db(geno_schema, 'Paechterstatistik', None, [], as_json=True, take_action=True, verbal=False)
    print('Produced files in', base_directory)
    count_of_ez = 0
    for paechter_details in ret_values:
        ### print(paechter_details)
        count_of_ez += 1

        rechnungs_empfaenger = {
            'name'     : paechter_details['Paechter_Vorname_Familienname'],
            'address'  : paechter_details['Paechter_Strasse'],
            'zip_code' : paechter_details['Paechter_Priv_PLZ'],
            'city'     : paechter_details['Paechter_Priv_Ort'],
            'country'  : '',
        }

        # pdfName = base_directory + title
        full_pdf_name = base_directory + str(paechter_details['Paechter_ID']) + '_EZ_' + title
        html_name = full_pdf_name + '.html'

        createQRInvoice(
            generateQRInvoiceData(
                format_IBAN(rechnungs_steller['IBAN']),
                rechnungs_steller,
                rechnungs_empfaenger,
                amount=format_float(paechter_details['Geno_Pachtzins']),
                additional_information=title + '/' + str(paechter_details['Paechter_ID'])),
            invoice_text_html="",
            pdfName=full_pdf_name,
            htmlName=html_name)

        print(getFilename(full_pdf_name + '.pdf'))
print('EZ produced:', count_of_ez)
