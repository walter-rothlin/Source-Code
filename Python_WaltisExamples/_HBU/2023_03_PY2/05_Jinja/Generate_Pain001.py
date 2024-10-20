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

from jinja2 import Environment, FileSystemLoader, Template
from datetime import *

def halt():
    input("Weiter?")

def get_pain001_template():
    pain001_template = '''
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Document xmlns="http://www.six-interbank-clearing.com/de/pain.001.001.03.ch.02.xsd">
    <CstmrCdtTrfInitn>
        <GrpHdr>
            <MsgId>{{ Debitor_Info.Header_ID }}</MsgId>
            <CreDtTm>{{ Debitor_Info.Creation_Time }}</CreDtTm>
            <NbOfTxs>{{ Zahlungs_liste|length }}</NbOfTxs>
            <CtrlSum>{{ summery_of_payments.total_amount }}</CtrlSum>
            <InitgPty>
                <Nm>{{ Debitor_Info.Name.strip() }}</Nm>
            </InitgPty>
        </GrpHdr>
        <PmtInf>
            <PmtInfId>{{ summery_of_payments.pain_id }}</PmtInfId>
            <PmtMtd>TRF</PmtMtd>
            <NbOfTxs>{{ summery_of_payments.count_of_payments }}</NbOfTxs>
            <PmtTpInf>
                <SvcLvl>
                    <Cd>SEPA</Cd>
                </SvcLvl>
            </PmtTpInf>
            <ReqdExctnDt>{{ Debitor_Info.Valuta }}</ReqdExctnDt>
            <Dbtr>
                <Nm>{{ Debitor_Info.Name.strip() }}</Nm>
                <PstlAdr>
                    <Ctry>{{ Debitor_Info.Country_Code.strip().upper() }}</Ctry>
                </PstlAdr>
            </Dbtr>
            <DbtrAcct>
                <Id>
                    <IBAN>{{ Debitor_Info.IBAN.replace(' ','').upper()  }}</IBAN>
                </Id>
            </DbtrAcct>
            <DbtrAgt>
                <FinInstnId>
                    <BIC>{{ Debitor_Info.BIC }}</BIC>
                </FinInstnId>
            </DbtrAgt>

            {% for a_payment in Zahlungs_liste %}
            <CdtTrfTxInf>
                <PmtId>
                    <InstrId>{{ loop.index}}</InstrId>
                    <EndToEndId>{{ loop.index + summery_of_payments.pain_start_id }}</EndToEndId>
                </PmtId>
                <Amt>
                    <InstdAmt Ccy="{{ a_payment.Ccy.replace(' ','').upper()  }}">{{ a_payment.Amount }}</InstdAmt>
                </Amt>
                <Cdtr>
                    <Nm>{{ a_payment.Receiver_Name.strip()  }}</Nm>
                </Cdtr>
                <CdtrAcct>
                    <Id>
                        <IBAN>{{ a_payment.IBAN.replace(' ','').upper() }}</IBAN>
                    </Id>
                </CdtrAcct>
                <RmtInf>
                    <Ustrd>{{ a_payment.Reason }}</Ustrd>
                </RmtInf>
            </CdtTrfTxInf>
            {% endfor %}
        </PmtInf>
    </CstmrCdtTrfInitn>
</Document>     
    '''
    return pain001_template

def get_pain001_msg(debitor_info, payment_list, template_path='./Templates', template_filename=None, pain_id='235805253558', pain_start_id=472100000000):
    total_amount = 0
    for a_payment in payment_list:
        total_amount += float(a_payment['Amount'])

    summery_of_payments = {
        'count_of_payments': len(payment_list),
        'total_amount': f'{str(round(total_amount,2))}',
        'pain_id': pain_id,
        'pain_start_id': pain_start_id,
    }

    if template_filename is not None:
        env = Environment(loader=FileSystemLoader(template_path))
        template = env.get_template(template_filename)
    else:
        template = Template(get_pain001_template())

    return template.render(summery_of_payments=summery_of_payments, Zahlungs_liste=payment_list, Debitor_Info=debitor_info)

# -------------------------------------------
# ++++++++++++ Main Main Main +++++++++++++++
# -------------------------------------------
if __name__ == '__main__':

    Debitor_Info_Geno = {
        'Header_ID': '547362488991',
        'Creation_Time': f'{datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%S.%f%z")}',  # 2023-11-17T14:48:04.485+01:00
        'Name': 'Genossame Wangen SZ',
        'Country_Code': 'CH',
        'IBAN': 'CH5100777001561771945',
        'BIC': 'KBSZCH22XXX',
        'Valuta': '2024-11-02'
    }

    Debitor_Info_WR = {
        'Header_ID': '547362488991',
        'Creation_Time': f'{datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%S.%f%z")}',  # 2023-11-17T14:48:04.485+01:00
        'Name': 'Walter Rothlin',
        'Country_Code': 'CH',
        'IBAN': 'CH4900777004546031980',  # Börsenkonto SZKB
        'BIC': 'KBSZCH22XXX',
        'Valuta': '2024-10-21'
    }


    Zahlungs_liste = [
        {'Ccy': 'CHF',
         'Amount': '2.95',
         'Receiver_Name': 'Tobias Rothlin',
         'IBAN': 'CH40 0077 7003 6561 2009 5',  # Haushaltsgeld SZKB
         'Reason': 'Test von PAIN001 (2.95)'},
        {'Ccy': 'chf',
         'Amount': '1.05',
         'Receiver_Name': '  Tobias Rothlin  ',
         'IBAN': 'ch40 0077 7003 6561 2009 5',  # Haushaltsgeld SZKB
         'Reason': 'Test von PAIN001 (1.05)'},
    ]

    pain001_msg = get_pain001_msg(debitor_info=Debitor_Info_WR, payment_list=Zahlungs_liste)
    print(pain001_msg)
    with open('generated_pain001.xml', 'w') as file:
        # Write the string to the file
        file.write(pain001_msg.strip())


    # halt()

    # pain001_msg = get_pain001_msg(debitor_info=Debitor_Info_WR, payment_list=Zahlungs_liste, template_filename='Pain001_template.xml')
    # print(pain001_msg)
