#!/usr/bin/python3

# ------------------------------------------------------------------------------------------------
# Name  : Generate_Pain001.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_HBU/2023_03_PY2/05_Jinja/Generate_Pain001.py
#
# Description: Generiert ein eBanking Upload-File für Zahlungen (Pain001.xml)
#
# Autor: Walter Rothlin
#
# History:
# 08-Jan-2023   Walter Rothlin      Initial Version
# ------------------------------------------------------------------------------------------------

from jinja2 import Environment, FileSystemLoader
from datetime import datetime


def get_pain001_msg(debitor_info, payment_list):
    total_amount = 0
    for a_payment in Zahlungs_liste:
        total_amount += float(a_payment['Amount'])

    summery_of_payments = {
        'count_of_payments': len(Zahlungs_liste),
        'total_amount': f'{str(round(total_amount,2))}'
    }

    env = Environment(loader=FileSystemLoader('./Templates'))
    template = env.get_template('Pain001_template.xml')
    return template.render(summery_of_payments=summery_of_payments, Zahlungs_liste=payment_list, Debitor_Info=debitor_info)

# -------------------------------------------
# ++++++++++++ Main Main Main +++++++++++++++
# -------------------------------------------
if __name__ == '__main__':
    formatted_timestamp = datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%S.%f%z")  # '2023-11-17T14:48:04.485+01:00'

    Debitor_Info = {
        'Header_ID': '547362488991',
        'Creation_Time': f'{datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%S.%f%z")}',  # 2023-11-17T14:48:04.485+01:00
        'Name': 'Genossame Wangen SZ',
        'Country_Code': 'CH',
        'IBAN': 'CH5100777001561771945',
        'BIC': 'KBSZCH22XXX',
        'Valuta': '2024-11-02'
    }

    Zahlungs_liste = [
        {'Ccy': 'CHF',
         'Amount': '1650.79',
         'Receiver_Name': 'Walter Rothlin',
         'IBAN': 'CH6400777000005824005',
         'Reason': 'Genossennutzen 2024'},
        {'Ccy': 'EUR',
         'Amount': '2000.23',
         'Receiver_Name': 'Max Meier',
         'IBAN': 'CH6400777000005824006',
         'Reason': 'Aufnahmegebühr'}
    ]

    pain001_msg = get_pain001_msg(debitor_info=Debitor_Info, payment_list=Zahlungs_liste)
    print(pain001_msg)
