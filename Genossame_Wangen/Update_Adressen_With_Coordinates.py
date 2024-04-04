#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Update_Adressen_With_Coordinates.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Genossame_Wangen/Update_Adressen_With_Coordinates.py
#
# Description: Liest über einen REST-Service
#
#
#
#
# Autor: Walter Rothlin
#
# History:
# 03-Apr-2024   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
from waltisLibrary import *


def get_adress_details_from_geo_admin(search_str, verbal=True):
    ret_val = {
        'Status_Meldung': '',
        'Anzahl_Results': 0,
        'Results': []

    }
    encoded_string = urllib.parse.quote(search_str)
    url_str = f'https://api3.geo.admin.ch/rest/services/api/SearchServer?sr=2056&searchText={encoded_string}&lang=en&type=locations'
    if verbal:
        print(url_str)

    res = requests.get(url_str)
    if res.status_code != 200:
        ret_val['Status_Meldung'] = "ERROR:" + res.status_code
        ret_val['Anzahl_Results'] = 0
        ret_val['Results'] = []
    else:
        resp = json.loads(res.text)['results']
        if verbal:
            print('Anzahl result found:', len(resp))

        if len(resp) == 0:
            ret_val['Status_Meldung'] = "WARNING: Nothing found!"
            ret_val['Anzahl_Results'] = 0
            ret_val['Results'] = []
        elif len(resp) == 1:
            ret_val['Status_Meldung'] = "INFO: Found!"
            ret_val['Anzahl_Results'] = 1
            ret_val['Results'] = resp
        else:
            ret_val['Status_Meldung'] = "WARNING: Too many found!"
            ret_val['Anzahl_Results'] = len(resp)
            ret_val['Results'] = resp
    return ret_val


# ================================================
# Main
# ================================================
adresse_str = input('Adresse:') # Peterliwiese 33'
res = get_adress_details_from_geo_admin(adresse_str)
if res['Anzahl_Results'] == 1:
    print(res['Results'])
print('\n\n', res)
