#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : Genossame_Manager.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Genossame_Manager/Stammdaten_Manager.py
#
# Description: Manager für Genossame-Daten
#
# Autor: Walter Rothlin
#
# History:
# 01-Jan-2023   Walter Rothlin      Initial Version
# 21-Jun-2023   Walter Rothlin      Added Commen_Defs
#
# ------------------------------------------------------------------
from Genossame_Common_Defs import *


def initial_load_pachtland(db_connection, filename,  verbal=False):
    print('initial_load_pachtland...reading', filename)
    myCursor = db_connection.cursor()

    # sql = """TRUNCATE `landteile`;"""
    sql = """DELETE FROM `landteile`;"""
    myCursor.execute(sql)
    db_connection.commit()

    info_tabellen_landwirte = openpyxl.load_workbook(filename, data_only=True)
    paechter_sheets = [x for x in info_tabellen_landwirte.sheetnames if "_" in x]
    # print('paechter_sheets:', paechter_sheets)

    for aPaechter_sheet_name in paechter_sheets:
        aPaechter_sheet = info_tabellen_landwirte[aPaechter_sheet_name]
        paechter_name = aPaechter_sheet["L3"].value
        Paechter_id = aPaechter_sheet["M3"].value
        print(f'Processing {Paechter_id:5d} {aPaechter_sheet_name:30s} {paechter_name:30s}', end='')
        row_index = 11
        landteil_count = 0
        while True:
            flurname = aPaechter_sheet["B"+str(row_index)].value
            if flurname is None:
                break
            elif flurname == 'Total Aren:':
                row_index += 1
                continue
            else:
                landteil_count += 1
                gis_id = aPaechter_sheet["A" + str(row_index)].value
                geno_id = aPaechter_sheet["C" + str(row_index)].value
                flaeche_in_aren = 0
                flaeche_geno = aPaechter_sheet["D" + str(row_index)].value
                if flaeche_geno is None:
                    flaeche_bürger = aPaechter_sheet["E" + str(row_index)].value
                    if flaeche_bürger is None:
                        flaeche_in_aren = '0'
                    else:
                        flaeche_in_aren = flaeche_bürger
                else:
                    flaeche_in_aren = flaeche_geno
                bemerkungen = aPaechter_sheet["F" + str(row_index)].value
                zins_pro_are = aPaechter_sheet["G" + str(row_index)].value
                if zins_pro_are is None:
                    zins_pro_are = 0
                fix_pacht_zins = aPaechter_sheet["H" + str(row_index)].value
                if zins_pro_are > 0:
                    fix_pacht_zins = 0


                verpächter_id = aPaechter_sheet["I" + str(row_index)].value
                if verpächter_id is None:
                    verpächter_name = (aPaechter_sheet["J" + str(row_index)].value).replace(' ', '')
                    verpächter_vorname = (aPaechter_sheet["K" + str(row_index)].value)
                    verpächter_id = get_personen_id(db_connection, such_kriterien=[verpächter_name, verpächter_vorname], verbal=False)

                # if geno_id == '313.100.1':
                #     print(gis_id, flurname, geno_id, flaeche_in_aren, bemerkungen, zins_pro_are, zins_total_genossame, verpächter_id)
                sql = """INSERT INTO landteile (AV_Parzellen_Nr, GENO_Parzellen_Nr, Flur_Bezeichnung, Flaeche_In_Aren, Pachtzins_Pro_Are, Fix_Pachtzins, Paechter_ID, Verpaechter_ID) 
                         VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"""
                val = (gis_id, geno_id, flurname, flaeche_in_aren, zins_pro_are, fix_pacht_zins, Paechter_id, verpächter_id)
                myCursor.execute(sql, val)
                db_connection.commit()

            row_index += 1
        print(f'   -> {landteil_count:5d}', )
        # break





# -------------------------------------------
# ++++++++++++ Main Main Main +++++++++++++++
# -------------------------------------------
db_attr_excel_column_mapping = [
    # Person_Details
    # --------------
    {'excel': 'Source'},
    {'excel': 'History'},
    {'excel': 'Bemerkungen'},
    {'excel': 'Zivilstand'},
    {'excel': 'Kategorien'},
    {'excel': 'Funktion'},
    {'excel': 'Firma'},

    {'excel': 'Geschlecht', 'db': 'Sex'},
    {'excel': 'Vorname'},
    {'excel': 'Vorname_2'},
    {'excel': 'Familien_Name', 'db': 'Pre'},
    {'excel': 'Ledig_Name'},
    {'excel': 'Partner_Name'},
    {'excel': 'Partner_Name_Angenommen'},

    {'excel': 'AHV_Nr'},
    {'excel': 'Betriebs_Nr'},

    {'excel': 'Baulandgesuch_Details'},
    {'excel': 'Bezahlte_Aufnahme_Gebühr'},
    {'excel': 'Ausbezahlter_Bürgertaglohn'},

    # Verwandtschaft
    # --------------
    {'excel': 'Partner_ID'},
    {'excel': 'Vater_ID'},
    {'excel': 'Mutter_ID'},

    # Private Adresse
    # ---------------
    {'excel': 'Private_Adressen_ID', 'db': 'Privat_Adressen_ID'},
    {'excel': 'Private_Strassen_Adresse', 'db': 'Pre'},
    {'excel': 'Private_Ort_ID', 'db': 'Pre'},
    {'excel': 'Private_PLZ_Ort', 'db': 'Pre'},
    {'excel': 'Private_Land_ID', 'db': 'Pre'},
    {'excel': 'Private_Land', 'db': 'Pre'},

    # Geschäft Adresse
    # ----------------
    {'excel': 'Geschaeft_Adressen_ID', 'db': 'Privat_Adressen_ID'},
    {'excel': 'Geschaeft_Strassen_Adresse', 'db': 'Pre'},
    {'excel': 'Geschaeft_Ort_ID', 'db': 'Pre'},
    {'excel': 'Geschaeft_PLZ_Ort', 'db': 'Pre'},
    {'excel': 'Geschaeft_Land_ID', 'db': 'Pre'},
    {'excel': 'Geschaeft_Land', 'db': 'Pre'},

    # Dates
    # -----
    {'excel': 'Geburtstag'},
    {'excel': 'Todestag'},
    {'excel': 'Nach_Wangen_Gezogen'},
    {'excel': 'Von_Wangen_Weggezogen'},
    {'excel': 'Baulandgesuch_Eingereicht_Am'},
    {'excel': 'Bauland_Gekauft_Am'},
    {'excel': 'Angemeldet_Am'},
    {'excel': 'Aufgenommen_Am'},
    {'excel': 'Sich_Für_Bürgertag_Angemeldet_Am'},
    {'excel': 'Neubürgertag_gemacht_Am'},
    {'excel': 'Funktion_Uebernommen_Am'},
    {'excel': 'Funktion_Abgegeben_Am'},
    {'excel': 'Chronik_Bezogen_Am'},
    {'excel': 'Newsletter_Abonniert_Am'},

    {'excel': 'eMail_Detail_Long',    'db': 'Join'},
    {'excel': 'eMail_1_Detail_Long',  'db': 'Join'},
    {'excel': 'eMail_2_Detail_Long',  'db': 'Join'},

    {'excel': 'Tel_Nr_Detail_Long',   'db': 'Join'},
    {'excel': 'Tel_Nr_1_Detail_Long', 'db': 'Join'},
    {'excel': 'Tel_Nr_2_Detail_Long', 'db': 'Join'},

    {'excel': 'IBAN_Detail_Long',     'db': 'Join'},

]

if __name__ == '__main__':

    geno_schema = db_connect(connect_to_prod=True, trace=True)

    # Initial Load
    # ============
    # initial_load_buerger(geno_schema, r'V:\Geno_Wangen_Daten.xlsx', verbal=True)
    # initial_load_pachtland(geno_schema, r'V:\Landwirtschaft\Pachtland\Infotabellen_Landwirte_2023_06_07.xlsx', verbal=True)


    # Process Aenderungen from Excel
    # ==============================
    print('\n\n')
    print('======================')
    print('Pre-Processing changes')
    print('======================')
    db_attr_excel_column_mapping_1 = [{'excel': 'Familien_Name'}, {'excel': 'Private_PLZ_Ort'}]
    pre_process_CUD(geno_schema, reco_data_fn=r'V:\Geno_Reco_Personen_Daten.xlsx', reco_sheetname='Reco_Personen_Daten', db_attr_excel_column_mapping=db_attr_excel_column_mapping_1, verbal=True, take_action=True)

    db_attr_excel_column_mapping_1 = [{'excel': 'Private_Strassen_Adresse'}]
    pre_process_CUD(geno_schema, reco_data_fn=r'V:\Geno_Reco_Personen_Daten.xlsx', reco_sheetname='Reco_Personen_Daten', db_attr_excel_column_mapping=db_attr_excel_column_mapping_1, verbal=True, take_action=True)

    print('\n\n')
    print('==================')
    print('Processing changes')
    print('==================')
    process_CUD(geno_schema, reco_data_fn=r'V:\Geno_Reco_Personen_Daten.xlsx', reco_sheetname='Reco_Personen_Daten', excel_db_field_mapping=db_attr_excel_column_mapping, verbal=True, take_action=True)



    # Cleanup Date
    # ============
    # execute_important_sql_queries(stammdaten_schema)

