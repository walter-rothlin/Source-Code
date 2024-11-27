#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: QR_EZ_Rothlin.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_Waltis/ExamplesQR_Codes_QR_Rechnung/QR_Rechnung_Tobias/QR_EZ_Rothlin.py
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
# 10-Feb-2024   Walter Rothlin      Made to Application for Rothlin Rechnungen
# ------------------------------------------------------------------
from Class_CSV_Data import *
from SwissQRInvoiceGenerator import *

ibanNr = {
    'walti_raiffeisen'      : "CH95 8080 8006 9894 2234 3",
    'walti_szkb_börsenkonto': "CH49 0077 7004 5460 3198 0",
    'walti_szkb_gemeinsam'  : "CH68 0077 7005 8268 7521 9",
    'walti_csuh'            : "CH87 0483 5041 1840 4100 0",
    'walti_cslachen'        : "CH39 0483 5056 3063 3100 0",

    'tobias_szkb_liegenschaften': "CH92 0077 7003 6561 2197 2",
    'tobias_szkb_lohnkonto'     : "CH40 0077 7003 6561 2009 5",
    'tobias_szkb_sparkonto'     : "CH34 0077 7000 0577 9404 1",

    'lukas_szkb_privat'     : "CH23 0077 7005 7794 4787 9",
    'lukas_szkb_spar'       : "CH23 0077 7000 0577 9443 3",
    'lukas_post_lohn'       : "CH27 0900 0000 3192 7263 8",
    'lukas_post_spar'       : "CH68 0900 0000 9241 3538 2",

    'claudia_szkb_börsenkonto' : "CH74 0077 7002 3265 2447 8",
    'claudia_raiffeisen_privat': "CH22 8080 8003 1592 9572 2",
    'claudia_raiffeisen_ET'    : "CH26 8080 8002 8098 7681 8",
    'claudia_raiffeisen_ET_Gemeinsam': "CH30 8080 8003 1157 2958 0",

    'remo_szkb_privat'      : "CH28 0077 7001 6831 9007 2",
    'FG_Abern'              : "CH90 0077 7003 2922 1166 7",
    'FDP Wangen SZ'         : "CH84 0077 7008 8504 5194 0",
    'uwe_kilger_post'       : "CH42 0900 0000 2533 9394 51",
    'geno_wangen'           : "CH51 0077 7001 5617 7194 5",
}

adressen = f"""
ID                   |Vorname_Name           |Adresse        |PLZ             |ORT         |Land  |IBAN
#--------------------+-----------------------+---------------+----------------+------------+------+----------------------------
Leer                 |                       |               |                |            |      | 
Walti                |Walter Rothlin         |Peterliwiese 33|8855            |Wangen SZ   |CH    |{ibanNr['walti_raiffeisen']}
Tobias               |Tobias Rothlin         |Peterliwiese 33|8855            |Wangen SZ   |CH    |{ibanNr['tobias_szkb_lohnkonto']}
Tobias_Liegenschaft  |Tobias Rothlin         |Peterliwiese 33|8855            |Wangen SZ   |CH    |{ibanNr['tobias_szkb_liegenschaften']}
Lukas                |Lukas Rothlin          |Peterliwiese 33|8855            |Wangen SZ   |CH    |{ibanNr['lukas_szkb_privat']}
Claudia_SZKB         |Claudia Collet         |Peterliwiese 33|8855            |Wangen SZ   |CH    |{ibanNr['claudia_szkb_börsenkonto']}
Claudia_Raiffeisen   |Claudia Collet         |Peterliwiese 33|8855            |Wangen SZ   |CH    |{ibanNr['claudia_raiffeisen_privat']}
Claudia_ET           |Claudia Collet         |Peterliwiese 33|8855            |Wangen SZ   |CH    |{ibanNr['claudia_raiffeisen_ET']}
Claudia_ET_Gemeinsam |Claudia Collet         |Peterliwiese 33|8855            |Wangen SZ   |CH    |{ibanNr['claudia_raiffeisen_ET_Gemeinsam']}

Uwe_Kilger           |Uwe Kilger             |Peterliwiese 33|8855            |Wangen SZ   |CH    |{ibanNr['uwe_kilger_post']}

FG_Aberen            |Flurgenossenschaft     |Aberen         |8858            |Innerthal   |      |{ibanNr['FG_Abern']}
Mieter_P33           |Fredi Kistler          |Peterliwiese 33|8855            |Wangen SZ   |      |
Mieter_Aubrigweg     |Roland Schweizer       |Aubrigweg 6    |8855            |Wangen SZ   |      |
Sepp_Vogel           |Josef Vogel            |Stockbergweg 37|8855            |Wangen SZ   |      |
Luca_Ragnolini       |Luca Ragnolini         |Pfändlergut 11 |8772            |Nidfurn     |      |
Genossame_Wangen     |Genossame Wangen       |Leuholz 12     |8855            |Wangen SZ   |      |{ibanNr['geno_wangen']}

"""

if __name__ == '__main__':
    person_date = CSV_Data(inputCsvStr=adressen)
    print(person_date)

    rechnungssteller_id = 'Walti'
    zahleradresse_id = 'Luca_Ragnolini'
    zu_zahlender_betrag = '750.00'
    mitteilung = 'Miete Wohnung Laax'
    path_name = r'E:\_WaltisDaten\Buchhaltung\__Einzahlungsscheine'
    path_name = r'.'


    do_loop = True
    while do_loop:

        file_name = f'From_{rechnungssteller_id}_to_{zahleradresse_id}'

        menu_text = f'''
        Einzahlungsscheine erstellen
        ============================
        
        1: Rechnungssteller ändern: {rechnungssteller_id}
        2: Zahler           ändern: {zahleradresse_id}
        3: Betrag           ändern: {zu_zahlender_betrag}
        4: Mitteilung       ändern: {mitteilung}
        5: Pfad             ändern: {path_name}
        6: Filename         ändern: {file_name}

        9: Rechnung erstellen

        0: Schluss
        '''

        print(menu_text)
        answer = input('   Wähle:')
        if answer == '1':
            rechnungssteller_id = input(rechnungssteller_id + ':')

        elif answer == '2':
            zahleradresse_id = input(zahleradresse_id + ':')

        elif answer == '3':
            zu_zahlender_betrag = input(zu_zahlender_betrag + ':')

        elif answer == '4':
            mitteilung = input(mitteilung + ':')

        elif answer == '5':
            path_name = input(path_name + ':')

        elif answer == '6':
            file_name = input(file_name + ':')

        elif answer == '9':
            print('Rechnungen erstellen')
            rechnungssteller = person_date.getValues(whereClause=f'ID == {rechnungssteller_id}', return_as_list=False)[0]
            print(rechnungssteller)

            zahleradresse = person_date.getValues(whereClause=f'ID == {zahleradresse_id}', return_as_list=False)[0]
            print(zahleradresse)

            creditor_iban = rechnungssteller['IBAN']
            creditor_addr = {
                "name": rechnungssteller['Vorname_Name'],
                "address": rechnungssteller['Adresse'],
                "zip_code": rechnungssteller['PLZ'],
                "city": rechnungssteller['ORT'],
                "country": rechnungssteller['Land']
            }

            debitor_addr = {
                "name": zahleradresse['Vorname_Name'],
                "address": zahleradresse['Adresse'],
                "zip_code": zahleradresse['PLZ'],
                "city": zahleradresse['ORT'],
                "country": zahleradresse['Land']
            }

            pdfName = path_name + '/' + file_name
            htmlName = file_name + '.html'
            createQRInvoice(
                generateQRInvoiceData(
                    creditor_iban=creditor_iban,
                    creditor_addr=creditor_addr,
                    debitor_addr=debitor_addr,
                    amount=zu_zahlender_betrag,
                    currency='CHF',
                    reference=None,
                    additional_information=mitteilung),
                invoice_text_html="",
                pdfName=pdfName,
                htmlName=htmlName)

            print("Produced following files:")
            print("    --> ", pdfName)
            print("    --> ", htmlName)

        elif answer == '0':
            do_loop = False

        else:
            print('WARNING: Ungültige Auswahl!!!')
