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
    gt_landteil_count = 0
    gt_streu_count = 0
    gt_geno_landteil_count = 0
    gt_buerger_landteil_count = 0
    gt_buerger_16a_count = 0
    gt_buerger_35a_count = 0

    # Deleting left overs in DB from Landteile
    # ----------------------------------------
    myCursor = db_connection.cursor()


    sql = """DELETE FROM `landteile`;"""    # sql = """TRUNCATE `landteile`;"""  # needs user rights
    myCursor.execute(sql)
    db_connection.commit()
    print(f'{myCursor.rowcount} Landteile wurden gelöscht ')

    if verbal:
        print('--> Calling stored-proc reset_table_autoincrement_landteile...', end='')
    args = ('landteile', 'x')
    result_args = myCursor.callproc('reset_table_autoincrement_landteile', args)
    print(result_args, end='')
    if verbal:
        print('....done\n')


    # Prcessing Info-Tables in Excel and load the Landteile
    # -----------------------------------------------------
    info_tabellen_landwirte = openpyxl.load_workbook(filename, data_only=True)
    paechter_sheets = [x for x in info_tabellen_landwirte.sheetnames if "_" in x]
    # print('paechter_sheets:', paechter_sheets)

    for aPaechter_sheet_name in paechter_sheets:
        if aPaechter_sheet_name in ['Bürgerteile_Speziell']:
            print(f'Not processing {aPaechter_sheet_name:20s}', end='\n')
            continue
        else:
            # print(f'Processing       {aPaechter_sheet_name:20s}', end='\n')
            pass

        if True:    # aPaechter_sheet_name in ['Müller_Urs']:
            aPaechter_sheet = info_tabellen_landwirte[aPaechter_sheet_name]
            paechter_name = aPaechter_sheet["L3"].value
            Paechter_id = aPaechter_sheet["M3"].value
            print(f'Processing {Paechter_id:5d} {aPaechter_sheet_name:30s} {paechter_name:30s}', end='')


            row_index = 11
            landteil_count = 0
            streu_count = 0
            geno_landteil_count = 0
            buerger_landteil_count = 0
            while True:
                flurname = aPaechter_sheet["B"+str(row_index)].value
                if flurname is None:
                    break
                elif flurname == 'Total Aren:':
                    row_index += 1
                    continue
                else:
                    landteil_count += 1
                    gt_landteil_count += 1
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

                    vorheriger_pächter_id = aPaechter_sheet["Q" + str(row_index)].value
                    vorheriger_verpächter_id = aPaechter_sheet["R" + str(row_index)].value

                    if verpächter_id == 625:
                        if flurname == 'Streue':
                            streu_count += 1
                            gt_streu_count += 1
                        else:
                            geno_landteil_count += 1
                            gt_geno_landteil_count += 1

                    else:
                        buerger_landteil_count += 1
                        gt_buerger_landteil_count += 1
                        if flaeche_bürger == 16:
                            gt_buerger_16a_count += 1
                        elif flaeche_bürger == 35:
                            gt_buerger_35a_count += 1
                        else:
                            print(f'WARNING: Bürgerlandteil nicht 16a oder 35a!!')

                    sql = """INSERT INTO landteile (AV_Parzellen_Nr, GENO_Parzellen_Nr, Flur_Bezeichnung, Flaeche_In_Aren, Bemerkungen, Pachtzins_Pro_Are, Fix_Pachtzins, Paechter_ID, Verpaechter_ID, Vorheriger_Paechter_ID, Vorheriger_Verpaechter_ID) 
                             VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""
                    val = (gis_id, geno_id, flurname, flaeche_in_aren, bemerkungen, zins_pro_are, fix_pacht_zins, Paechter_id, verpächter_id, vorheriger_pächter_id, vorheriger_verpächter_id)
                    if False and geno_id in ['126.200.1', '126.200.2']:
                        print(val)
                    myCursor.execute(sql, val)
                    db_connection.commit()

                row_index += 1
            print(f'   -> {landteil_count:2d} (Geno:{geno_landteil_count:2d} + Bürger:{buerger_landteil_count:2d} + Streue:{streu_count:2d})')
    print(f'  Total:{gt_landteil_count:2d} (Geno:{gt_geno_landteil_count:2d} + Bürger:{gt_buerger_landteil_count:2d} + Streue:{gt_streu_count:2d})')
    print(f'  Detail Bürgerteile:{gt_buerger_landteil_count:2d} = 16a:{gt_buerger_16a_count:2d} + 35a:{gt_buerger_35a_count:2d})')

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
    {'excel': 'SAK'},

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
    {'excel': 'Aufnahme_Gebühr_bezahlt_Am'},
    {'excel': 'Aufgenommen_Am'},
    {'excel': 'Sich_Für_Bürgertag_Angemeldet_Am'},
    {'excel': 'Sich_Für_Bürgertag_definitiv_abgemeldet_Am'},
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
    #
    if False:
        initial_load_pachtland(geno_schema, r'V:\Landwirtschaft\Pachtland\Infotabellen_Landwirte.xlsx', verbal=True)


    if True:
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

    if True:
        print('\n\n')
        print('==================')
        print('Processing changes')
        print('==================')
        process_CUD(geno_schema, reco_data_fn=r'V:\Geno_Reco_Personen_Daten.xlsx', reco_sheetname='Reco_Personen_Daten', excel_db_field_mapping=db_attr_excel_column_mapping, verbal=True, take_action=True)



    # Cleanup Date
    # ============
    if True:
        print('\n\n')
        print('==================')
        print('Cleanup DB        ')
        print('==================')
        execute_important_sql_queries(geno_schema)

