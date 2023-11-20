#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 03_03_fct_calls.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/_HBU/2023_Rpi/03_03_fct_calls.py
#
# Description: Beispiele für fct calls
#
# Autor: Walter Rothlin
#
# History:
#25-Sep-2023   Walter Rothlin      Initial Version
#
# ------------------------------------------------------------------

def summe(*summanden):
    ret_val = 0
    # print('*summanden:', summanden)
    for a_summand in summanden:
        ret_val += a_summand
    return ret_val

def notendurchschnitt(*einzelnoten, **kommentar):
    print('einzelnoten:', einzelnoten)
    print('kommentar  :', kommentar)
    a_summe = 0
    for eine_note in einzelnoten:
        a_summe += eine_note
    anzahl_noten = len(einzelnoten)
    return a_summe/anzahl_noten


print('5       =',notendurchschnitt(5))
print('5, 6    =',notendurchschnitt(5,6))
print('5, 6, 7 =',notendurchschnitt(5,6,7, end='Hallo', start='Anfang'))


stueckzahl = 5
preis = 34.56789

print('{stueck:3d} zu {ePreis:10.2f} = {totPreis:10.2f}'.format(totPreis=preis*stueckzahl, ePreis=preis, stueck=stueckzahl))
print(f'{stueckzahl:3d} zu {preis:10.2f} = {preis*stueckzahl:10.2f}')


stueckzahl = 10
preis = 1.20

print('{stueck:3d} zu {ePreis:10.2f} = {totPreis:10.2f}'.format(totPreis=preis*stueckzahl, ePreis=preis, stueck=stueckzahl))
