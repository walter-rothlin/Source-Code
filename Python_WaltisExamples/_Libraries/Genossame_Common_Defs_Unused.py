#!/usr/bin/python3

# ------------------------------------------------------------------------------------------------
# Name  : Genossame_Common_Defs_Unused.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Genossame_Manager/Genossame_Common_Defs_Unused.py
#
# Description: Old, Unused for Genossame-Daten
#
# Autor: Walter Rothlin
#
# History:
# 08-Oct-2023   Walter Rothlin      Initial Version
# ------------------------------------------------------------------------------------------------
from Genossame_Common_Defs  import *

# -------------------------------------------------------------------
# ++++++++++++ Alte, nicht mehr gebrauchte Funktionen +++++++++++++++
# -------------------------------------------------------------------

def TEST_update_or_insert_value(db_connection):
    test_value = {'eMail': 'walter@Rothlin.com'}
    print(update_or_insert_value(db_connection, '644', 'eMai_adressen', test_value, verbal=True))
    test_value = {'eMail': 'walterr@Rothlin.com'}
    print(update_or_insert_value(db_connection, '223', 'eMai_adressen', test_value, verbal=True))





# ---------------------------------------------
# Functions inital load Buergerdaten
# ---------------------------------------------
def import_data_from_EXCEL(filename, sheet_name, csv_db_col_mapping={}, db=None, db_tbl_name=None, verbal=False, ingnore_sql_error=False):
    sheet_data = pd.read_excel(filename, sheet_name=sheet_name)
    csv_column_names = csv_db_col_mapping.keys()
    # print('columns:', csv_column_names)
    df = pd.DataFrame(sheet_data, columns=csv_column_names)

    row_counter_file_loaded = 0
    row_counter_file_not_loaded = 0
    mycursor = db.cursor()
    for index, row in df.iterrows():
        row_counter_file_loaded += 1
        csv_values = []
        db_attributes_names = []

        for a_csv_column_name in csv_column_names:
            default_value = str(csv_db_col_mapping[a_csv_column_name].get('default_value'))
            attribute_type = str(csv_db_col_mapping[a_csv_column_name].get('db_attribute_type'))
            a_csv_column_value = str(row[a_csv_column_name]).replace("'", "\\'")

            # print('1)', a_csv_column_name, ':: ', attribute_type, ': ', a_csv_column_value, '  (', default_value, ')', sep='', end='')
            if (a_csv_column_value == 'nan' or a_csv_column_value == 'NaT' or a_csv_column_value == ''):
                if default_value != '':
                    a_csv_column_value = default_value
                else:
                    a_csv_column_value = ""
            elif a_csv_column_value == 'False':
                a_csv_column_value = "0"
            elif a_csv_column_value == 'True':
                a_csv_column_value = "1"
            else:
                pass

            # print('-->', attribute_type)
            if attribute_type == 'int':
                # print('RegEx:', a_csv_column_value)
                a_csv_column_value = convert_str_to_int(a_csv_column_value)
            # print('   Final:', a_csv_column_value)
            if a_csv_column_value is not None and a_csv_column_value != 'None':
                if attribute_type == 'int':
                    csv_values.append(str(a_csv_column_value))
                    # csv_values.append('{zahl:11d}'.format(zahl=a_csv_column_value))
                else:
                    csv_values.append("'" + a_csv_column_value + "'")
                db_attributes_names.append(str(csv_db_col_mapping[a_csv_column_name]['db_table_attribute_name']))

        csv_values_as_string = ', '.join(csv_values)
        db_attributes_names_as_string = ', '.join(db_attributes_names)


        # print('db_attributes_types:', db_attributes_types)

        if ingnore_sql_error:
            sql_insert = f'''
             INSERT IGNORE INTO {db_tbl_name} ({db_attributes_names_as_string}) VALUES 
                    ({csv_values_as_string})
            '''
        else:
            sql_insert = f'''
             INSERT INTO {db_tbl_name} ({db_attributes_names_as_string}) VALUES 
                    ({csv_values_as_string})
            '''

        try:
            mycursor.execute(sql_insert)
        except Exception:
            if verbal:
                print('ERROR:', sql_insert)
            row_counter_file_not_loaded += 1
    db.commit()

    prompt_file = 'rows_in_file (' + sheet_name + '):'
    rec_count_file = {prompt_file: row_counter_file_loaded}

    prompt_db = 'rows_in_db   (' + db_tbl_name + '):'
    rec_count_db = get_record_count(db, db_tbl_name)

    prompt_not_loaded = 'rows_not_loaded:'
    rec_not_loaded = {prompt_not_loaded: row_counter_file_not_loaded}

    if rec_count_file[prompt_file] != rec_count_db[prompt_db]:
        print('\nWARNING:')
        if verbal:
            print('1) rec_count_db  :', str(rec_count_db))
            print('2) rec_count_file:', str(rec_count_file))
            print('3) rec_not_loaded:', str(rec_not_loaded))


    return [rec_count_file, rec_count_db, rec_not_loaded]

def inital_load_fromExcel(input_fn, db_connection, doit=False):
    if doit:
        initial_load(input_fn, ['Länder', 'Orte', 'Adressen', 'Personen'], db_connection)
        initial_load(input_fn, ['IBAN'], db_connection)
        initial_load(input_fn, ['EMail', 'Person_Has_EMail'], db_connection)
        initial_load(input_fn, ['Telefon', 'Person_Has_Telefonnummer'], db_connection)

def initial_load(inport_excel_fn, tables_to_load, db_connection):
    for a_table in tables_to_load:
        if a_table == 'Länder':
            resultat = import_data_from_EXCEL(inport_excel_fn,
                                   sheet_name='Länder',
                                   csv_db_col_mapping={'ID': {'db_table_attribute_name': 'ID'},
                                                       'Land': {'db_table_attribute_name': 'Name'},
                                                       'Code': {'db_table_attribute_name': 'Code'},
                                                       'Landesvorwahl': {'db_table_attribute_name': 'Landesvorwahl'},
                                                       'last_update': {'db_table_attribute_name': 'last_update'}
                                                       },
                                   db=db_connection,
                                   db_tbl_name='Land')
            print(resultat)

        if a_table == 'Orte':
            resultat = import_data_from_EXCEL(inport_excel_fn,
                                   sheet_name='Orte',
                                   csv_db_col_mapping={'ID': {'db_table_attribute_name': 'ID'},
                                                       'PLZ': {'db_table_attribute_name': 'PLZ'},
                                                       'Name': {'db_table_attribute_name': 'Name'},
                                                       'Kanton': {'db_table_attribute_name': 'Kanton'},
                                                       'Land_ID': {'db_table_attribute_name': 'Land_ID'},
                                                       'last_update': {'db_table_attribute_name': 'last_update'}
                                                       },
                                   db=db_connection,
                                   db_tbl_name='Orte')
            print(resultat)

        if a_table == 'Adressen':
            resultat = import_data_from_EXCEL(inport_excel_fn,
                                   sheet_name='Adressen',
                                   csv_db_col_mapping={'ID': {'db_table_attribute_name': 'ID'},
                                                       'Strasse': {'db_table_attribute_name': 'Strasse'},
                                                       'Hausnummer': {'db_table_attribute_name': 'Hausnummer'},
                                                       'Postfachnummer': {'db_table_attribute_name': 'Postfachnummer'},
                                                       'Adresszusatz': {'db_table_attribute_name': 'Adresszusatz'},
                                                       'Wohnung': {'db_table_attribute_name': 'Wohnung'},
                                                       'Kataster_Nr': {'db_table_attribute_name': 'Kataster_Nr'},
                                                       'x_CH1903': {'db_table_attribute_name': 'x_CH1903'},
                                                       'Y_CH1903': {'db_table_attribute_name': 'y_CH1903'},
                                                       'Politisch_Wangen': {'db_table_attribute_name': 'Politisch_Wangen'},
                                                       'Ort_ID': {'db_table_attribute_name': 'Orte_ID'},
                                                       'last_update': {'db_table_attribute_name': 'last_update'}
                                                       },
                                   db=db_connection,
                                   db_tbl_name='Adressen')
            print(resultat)

        if a_table == 'Personen':
            '''
            'Partner_ID': {'db_table_attribute_name': 'Partner_ID',
                           'default_value': 'None',
                           'db_attribute_type': 'int'},
            'Vater_ID': {'db_table_attribute_name': 'Vater_ID',
                           'default_value': 'None',
                           'db_attribute_type': 'int'},
            'Mutter_ID': {'db_table_attribute_name': 'Mutter_ID',
                           'default_value': 'None',
                           'db_attribute_type': 'int'},
            '''
            resultat = import_data_from_EXCEL(inport_excel_fn,
                                   sheet_name='Personen',
                                   csv_db_col_mapping={'ID': {'db_table_attribute_name': 'ID'},
                                                       'Source': {'db_table_attribute_name': 'Source'},
                                                       'History': {'db_table_attribute_name': 'History'},
                                                       'Bemerkungen': {'db_table_attribute_name': 'Bemerkungen'},
                                                       'Sex': {'db_table_attribute_name': 'Sex'},
                                                       'Firma': {'db_table_attribute_name': 'Firma'},
                                                       'Vorname': {'db_table_attribute_name': 'Vorname'},
                                                       'Vorname_2': {'db_table_attribute_name': 'Vorname_2'},
                                                       'Ledig_Name': {'db_table_attribute_name': 'Ledig_Name'},
                                                       'Partner_Name': {'db_table_attribute_name': 'Partner_Name'},
                                                       'Partner_Name_Angenommen': {'db_table_attribute_name': 'Partner_Name_Angenommen'},
                                                       'AHV_Nr': {'db_table_attribute_name': 'AHV_Nr'},
                                                       'Betriebs_Nr': {'db_table_attribute_name': 'Betriebs_Nr'},
                                                       'Zivilstand': {'db_table_attribute_name': 'Zivilstand'},
                                                       'Kategorien': {'db_table_attribute_name': 'Kategorien'},
                                                       'Geburtstag': {'db_table_attribute_name': 'Geburtstag'},
                                                       'Todestag': {'db_table_attribute_name': 'Todestag'},
                                                       'Nach_Wangen_Gezogen': {'db_table_attribute_name': 'Nach_Wangen_Gezogen'},
                                                       'Von_Wangen_Weggezogen': {'db_table_attribute_name': 'Von_Wangen_Weggezogen'},
                                                       'Baulandgesuch_Eingereicht_Am': {'db_table_attribute_name': 'Baulandgesuch_Eingereicht_Am'},
                                                       'Bauland_Gekauft_Am': {'db_table_attribute_name': 'Bauland_Gekauft_Am'},
                                                       'Baulandgesuch_Details': {'db_table_attribute_name': 'Baulandgesuch_Details'},
                                                       'Angemeldet_Am': {'db_table_attribute_name': 'Angemeldet_Am'},
                                                       'Bezahlt_Aufnahme_Gebühr': {'db_table_attribute_name': 'Bezahlt_Aufnahme_Gebühr'},
                                                       'Aufgenommen_Am': {'db_table_attribute_name': 'Aufgenommen_Am'},
                                                       'Sich_Für_Bürgertag_Angemeldet_Am': {'db_table_attribute_name': 'Sich_Für_Bürgertag_Angemeldet_Am'},
                                                       'Neubürgertag_gemacht_Am': {'db_table_attribute_name': 'Neubürgertag_gemacht_Am'},
                                                       'Ausbezahlter_Bürgertaglohn': {'db_table_attribute_name': 'Ausbezahlter_Bürgertaglohn'},
                                                       'Funktion_Uebernommen_Am': {'db_table_attribute_name': 'Funktion_Uebernommen_Am'},
                                                       'Funktion_Abgegeben_Am': {'db_table_attribute_name': 'Funktion_Abgegeben_Am'},
                                                       'Chronik_Bezogen_Am': {'db_table_attribute_name': 'Chronik_Bezogen_Am'},
                                                       'Newsletter_Abonniert_Am': {'db_table_attribute_name': 'Newsletter_Abonniert_Am'},
                                                       'Privat_Adressen_ID': {'db_table_attribute_name': 'Privat_Adressen_ID'},
                                                       'Geschaefts_Adressen_ID': {'db_table_attribute_name': 'Geschaefts_Adressen_ID'},
                                                       'last_update': {'db_table_attribute_name': 'last_update'}
                                                       },
                                   db=db_connection,
                                   db_tbl_name='Personen')
            print(resultat)

        if a_table == 'IBAN':
            resultat = import_data_from_EXCEL(inport_excel_fn,
                                   sheet_name='IBAN_Liste',
                                   csv_db_col_mapping={'IBAN_ID': {'db_table_attribute_name': 'ID'},
                                                       'IBAN_Nummer': {'db_table_attribute_name': 'Nummer'},
                                                       'Bezeichnung': {'db_table_attribute_name': 'Bezeichnung'},
                                                       'Bankname': {'db_table_attribute_name': 'Bankname'},
                                                       'Bankort': {'db_table_attribute_name': 'Bankort'},
                                                       'Pers_ID': {'db_table_attribute_name': 'Personen_ID'},
                                                       'Prio': {'db_table_attribute_name': 'Prio'},
                                                       'last_update': {'db_table_attribute_name': 'last_update'}
                                                       },
                                   db=db_connection,
                                   db_tbl_name='IBAN')
            print(resultat)

        if a_table == 'EMail':
            resultat = import_data_from_EXCEL(inport_excel_fn,
                                   verbal=False,
                                   sheet_name='EMail_Liste',
                                   csv_db_col_mapping={'Email_ID': {'db_table_attribute_name': 'ID'},
                                                       'eMail_adresse': {'db_table_attribute_name': 'eMail'},
                                                       'Type': {'db_table_attribute_name': 'Type'},
                                                       'Prio': {'db_table_attribute_name': 'Prio'},
                                                       'last_update': {'db_table_attribute_name': 'last_update'}
                                                       },
                                   db=db_connection,
                                   db_tbl_name='email_adressen')
            print(resultat)

        if a_table == 'Person_Has_EMail':
            resultat = import_data_from_EXCEL(inport_excel_fn,
                                   sheet_name='EMail_Liste',
                                   csv_db_col_mapping={'Pers_ID': {'db_table_attribute_name': 'Personen_ID'},
                                                       'Email_ID': {'db_table_attribute_name': 'EMail_adressen_ID'},
                                                       'last_update': {'db_table_attribute_name': 'last_update'}
                                                       },
                                   db=db_connection,
                                   db_tbl_name='personen_has_email_adressen')
            print(resultat)

        if a_table == 'Telefon':
            resultat = import_data_from_EXCEL(inport_excel_fn,
                                   verbal=False,
                                   sheet_name='Telefon_Liste',
                                   csv_db_col_mapping={'Tel_ID': {'db_table_attribute_name': 'ID'},
                                                       'Laendercode': {'db_table_attribute_name': 'Laendercode'},
                                                       'Vorwahl': {'db_table_attribute_name': 'Vorwahl'},
                                                       'Nummer': {'db_table_attribute_name': 'Nummer'},
                                                       'Type': {'db_table_attribute_name': 'Type'},
                                                       'Endgeraet': {'db_table_attribute_name': 'Endgeraet'},
                                                       'Prio': {'db_table_attribute_name': 'Prio'},
                                                       'last_update': {'db_table_attribute_name': 'last_update'}
                                                       },
                                   db=db_connection,
                                   db_tbl_name='Telefonnummern')
            print(resultat)

        if a_table == 'Person_Has_Telefonnummer':
            resultat = import_data_from_EXCEL(inport_excel_fn,
                                   sheet_name='Telefon_Liste',
                                   csv_db_col_mapping={'Pers_ID': {'db_table_attribute_name': 'Personen_ID'},
                                                       'Tel_ID': {'db_table_attribute_name': 'Telefonnummern_ID'},
                                                       'last_update': {'db_table_attribute_name': 'last_update'}
                                                       },
                                   db=db_connection,
                                   db_tbl_name='personen_has_telefonnummern')
            print(resultat)


def initial_load_buerger(stammdaten_schema, excel_file, verbal=False):
    inital_load_fromExcel(excel_file, stammdaten_schema, doit=True)

# ---------------------------------------------
# Functions für Reco email_telnr_IBAN migration
# ---------------------------------------------

def updates_from_excel(filename, sheet_name, db_connection, verbal=True, take_action=False):
    if verbal:
        print(f'''
       --> Calling updates_from_excel({filename},
                                      {sheet_name},
                                      db_connection,
                                      verbal={verbal},
                                      take_action={take_action})''')

    update_count = 0
    sheet_data = pd.read_excel(filename, sheet_name=sheet_name)
    print('Updateing eMail, Tel_Nr, IBAN..   ', end='')
    if verbal:
        print()
    df = pd.DataFrame(sheet_data, columns=['ID', 'eMail_ID', 'eMail', 'Tel_Nr_ID', 'Tel_Nr', 'IBAN_ID', 'IBAN'])
    rec_updated = 0
    for index, row in df.iterrows():
        # print()
        # print(index, row)
        pers_ID = str(row[0]).replace('.0', '')
        email_ID = str(row[1]).replace('.0', '')
        email = str(row[2])
        if email_ID != 'nan' and email != 'nan':
            update_count += update_if_neccessary(db_connection, 'email_adressen', email_ID, 'eMail', email, verbal=True, take_action=take_action)

        tel_nr_ID = str(row[3]).replace('.0', '')
        tel_nr = str(row[4]).replace(' ', '')
        if tel_nr_ID != 'nan' and tel_nr != 'nan':
            update_count += update_if_neccessary(db_connection, 'telefonnummern', tel_nr_ID, 'nummer', tel_nr, verbal=True, take_action=take_action)

        iban_ID = str(row[5]).replace('.0', '')
        iban = str(row[6]).replace(' ', '')
        if iban_ID != 'nan' and iban != 'nan':
            # print(pers_ID, IBAN_ID, IBAN)
            update_count += update_if_neccessary(db_connection, 'iban', iban_ID, 'nummer', iban, verbal=True, take_action=take_action)

    return update_count


def email_telnr_IBAN_migrieren(stammdaten_schema, reco_data_fn, reco_sheetname, verbal=False, take_action=False):
    if verbal:
        print(f'''
           --> Calling email_telnr_IBAN_migrieren(stammdaten_schema,
                                                  {reco_data_fn}, 
                                                  {reco_sheetname}, 
                                                  verbal={verbal}, 
                                                  take_action={take_action})''')
    do_inserts_from_reco = True
    if do_inserts_from_reco:
        rc = 0
        # rc += inserts_from_excel(reco_data_fn, reco_sheetname, 'EMAIL', stammdaten_schema, verbal=verbal, take_action=take_action)
        # rc += inserts_from_excel(reco_data_fn, reco_sheetname, 'TELNR', stammdaten_schema, verbal=verbal, take_action=take_action)
        # rc += inserts_from_excel(reco_data_fn, reco_sheetname, 'IBAN' , stammdaten_schema, verbal=verbal, take_action=take_action)

        if rc > 0:
            print(f"""

            ---> All ({rc}) insert processed from
                    {reco_data_fn}
                    {reco_sheetname}
            """)
        else:
            print(f"""

            ---> No inserts found in
                    {reco_data_fn}
                    {reco_sheetname}
            """)

    do_updates_from_reco = False
    if do_updates_from_reco:
        rc = 0
        rc += updates_from_excel(reco_data_fn, reco_sheetname, stammdaten_schema, verbal=verbal, take_action=take_action)

        if rc > 0:
            print(f"""

            ---> All ({rc}) updates processed from
                    {reco_data_fn}
                    {reco_sheetname}
            """)
        else:
            print(f"""

            ---> No updates found in
                    {reco_data_fn}
                    {reco_sheetname}
            """)



def inserts_from_excel(filename, sheet_name, attribut, db_connection, verbal=True, take_action=False):

    if verbal:
        print(f'''
       --> Calling inserts_from_excel({filename}, 
                                      {sheet_name}, 
                                      {attribut}, 
                                      db_connection, 
                                      verbal={verbal}, 
                                      take_action={take_action})''')

    myCursor = db_connection.cursor()
    insert_count = 0
    sheet_data = pd.read_excel(filename, sheet_name=sheet_name)


    if attribut == 'EMAIL':
        print('Adding eMail adresses ..', end='')
        if verbal:
            print()

        df = pd.DataFrame(sheet_data, columns=['ID', 'eMail_ID', 'eMail'])
        for index, row in df.iterrows():
            # print()
            # print(index, row)
            pers_ID = str(row[0]).replace('.0', '')
            email_ID = str(row[1]).replace('.0', '')
            email = str(row[2])
            if email_ID == 'nan' and email != 'nan':
                insert_count += 1
                args = (pers_ID, email, 'Sonstige', 0, 'x')  # 'x' in the Tuple will be replaced by OUT-Value
                if verbal:
                    print('    addEmailAdr', str(args), sep='')
                if take_action:
                    result_args = myCursor.callproc('addEmailAdr', args)


    if attribut == 'TELNR':
        insert_count = 0
        print('Adding TelNrs         ..', end='')
        if verbal:
            print()

        df = pd.DataFrame(sheet_data, columns=['ID', 'Tel_Nr_ID', 'Tel_Nr'])
        for index, row in df.iterrows():
            pers_ID = str(row[0]).replace('.0', '')
            telnr_ID = str(row[1]).replace('.0', '')
            telnr = str(row[2]).replace(' ', '')
            if telnr_ID == 'nan' and telnr != 'nan':
                insert_count += 1
                if telnr == 'keine':
                    vorwahl = ''
                else:
                    vorwahl = telnr[0:3]
                    telnr   = telnr[3:]
                if vorwahl == '055':
                    endgeraet = 'Festnetz'
                else:
                    endgeraet = 'Mobile'
                args = (pers_ID, '0041', vorwahl, telnr, 'Privat', endgeraet, 0, 'x')  # 'x' in the Tuple will be replaced by OUT-Value
                if verbal:
                    print('    addTelNr', str(args), sep='')
                if take_action:
                    result_args = myCursor.callproc('addTelNr', args)


    if attribut == 'IBAN':
        insert_count = 0
        print('Adding IBAN           ..', end='')
        if verbal:
            print()

        df = pd.DataFrame(sheet_data, columns=['ID', 'IBAN_ID', 'IBAN'])
        for index, row in df.iterrows():
            pers_ID = str(row[0]).replace('.0', '')
            iban_ID = str(row[1]).replace('.0', '')
            iban = str(row[2])    # .replace(' ', '')
            # print(pers_ID, iban_ID, iban)
            if iban_ID == 'nan' and iban != 'nan':
                insert_count += 1
                args = (pers_ID, iban, 'x')
                if verbal:
                    print('    addIBAN', str(args), sep='')
                if take_action:
                    result_args = myCursor.callproc('addIBAN', args)

    print('    .. ', insert_count, 'reord(s) processed!')
    return insert_count





def news_letter_daten_migrieren(stammdaten_schema, excel_file, verbal=False):
    # Newsletter Daten migrieren
    do_reco_Newsletter_set_id = False
    if do_reco_Newsletter_set_id:
        print('\n\n\n======> Newsletter Daten migrieren')
        excel_sheet = 'Mailadressen aktuell'
        workbook = openpyxl.load_workbook(excel_file, data_only=True)
        worksheet_sheet = workbook[excel_sheet]

        row = 2
        while worksheet_sheet["B" + str(row)].value is not None:
            if (worksheet_sheet["A" + str(row)].value is None) or (worksheet_sheet["A" + str(row)].value == '?') or (',' in str(worksheet_sheet["A" + str(row)].value)):
                such_kriterien = []
                such_kriterien.append(worksheet_sheet["B" + str(row)].value)
                such_kriterien.append(worksheet_sheet["D" + str(row)].value)
                if worksheet_sheet["C" + str(row)].value is not None:
                    such_kriterien.append(worksheet_sheet["C" + str(row)].value)
                elif worksheet_sheet["E" + str(row)].value is not None:
                    strasse = worksheet_sheet["E" + str(row)].value
                    strasse = strasse.replace('strasse', 'str.')
                    such_kriterien.append(strasse)
                # print(get_personen_id(stammdaten_schema, such_kriterien, verbal=False))
                people_found = get_personen_ids(stammdaten_schema, such_kriterien, verbal=verbal)

                ids = []
                for aRec in people_found:
                    ids.append(str(aRec[0]))
                ids_str = ','.join(ids)
                if len(ids) == 1:
                    worksheet_sheet["A" + str(row)] = str(ids[0])

                elif len(ids) == 0:
                    print('--> ', str(such_kriterien))
                    worksheet_sheet["A" + str(row)] = '?'

                else:
                    worksheet_sheet["A" + str(row)] = ids_str
                    print('==> ', str(such_kriterien))
                    worksheet_sheet["J" + str(row)] = str(people_found)
                    print('people_found (', len(people_found), '):', people_found, end='\n\n\n')

            row += 1
        workbook.save(excel_file)
        workbook.close()

    # do compare and take over
    print('\n\n\n======> Compare and take over Data')
    workbook = openpyxl.load_workbook(excel_file, data_only=True)
    worksheet_sheet = workbook[excel_sheet]
    row = 2
    while worksheet_sheet["B" + str(row)].value is not None:
        pers_id = worksheet_sheet["A" + str(row)].value
        if (pers_id is not None) and (pers_id != '?') and (pers_id != 'F') and (pers_id != 'H') and (',' not in str(pers_id)):
            geb_datum = worksheet_sheet["F" + str(row)].value
            eMail_adr = worksheet_sheet["G" + str(row)].value
            if eMail_adr is not None:
                eMail_adr = str(eMail_adr).replace('mailto:', '')
            Natel_Nr = worksheet_sheet["H" + str(row)].value
            bemerkungen = worksheet_sheet["I" + str(row)].value
            ## print('+++++', pers_id, geb_datum, eMail_adr, Natel_Nr, bemerkungen)
            if geb_datum is None and eMail_adr is None and Natel_Nr is None and bemerkungen is None:
                worksheet_sheet["B" + str(row)].value = ''
                worksheet_sheet["C" + str(row)].value = ''
                worksheet_sheet["D" + str(row)].value = ''
                worksheet_sheet["E" + str(row)].value = ''

            if eMail_adr is not None and eMail_adr != '':
                # print(f"update_or_insert_value({pers_id}, 'eMai_adressen', '{eMail_adr}')")
                up_ins_count = update_or_insert_value(stammdaten_schema, pers_id, 'eMai_adressen', {'eMail': eMail_adr, 'Type': 'Sonstige', 'Prio': 0}, verbal=verbal)
                if up_ins_count['count_of_matches'] == 1:
                    worksheet_sheet["G" + str(row)].value = ''

                print('email count_of_inserts:', up_ins_count['count_of_inserts'])
                print('email count_of_updates:', up_ins_count['count_of_updates'])
                print('email count_of_matches:', up_ins_count['count_of_matches'])
                # halt('Weiter_06:')
                # print('eMai_adressen', up_ins_count)
            if Natel_Nr is not None and Natel_Nr != '':
                up_ins_count = update_or_insert_value(stammdaten_schema, pers_id, 'telefon_nummer', {'tel_nr': Natel_Nr, 'Type': 'Private', 'Endgeraet': 'Mobile', 'Prio': 0}, verbal=verbal)
                if up_ins_count['count_of_matches'] == 1:
                    worksheet_sheet["H" + str(row)].value = ''
                # print('telefon_nummer', up_ins_count)
            if geb_datum is not None and geb_datum != '':
                up_ins_count = update_or_insert_value(stammdaten_schema, pers_id, 'Geburtstag', {'Date': geb_datum})
                if up_ins_count['count_of_matches'] == 1:
                    worksheet_sheet["F" + str(row)].value = ''
                # print('Geburtstag', up_ins_count)
            up_ins_count = update_or_insert_value(stammdaten_schema, pers_id, 'Newsletter_Abonniert_Am', {'Date': '2023.06.20'})
            # print('Newsletter_Abonniert_Am', up_ins_count)
        elif pers_id == 'F' or pers_id == 'H':
            if pers_id == 'F':
                sex = 'Frau'
            else:
                sex = 'Herr'
            Nachname = worksheet_sheet["B" + str(row)].value
            Nachname_2 = worksheet_sheet["C" + str(row)].value
            Vorname = worksheet_sheet["D" + str(row)].value
            geb_datum = str(worksheet_sheet["F" + str(row)].value)
            print('geb_datum:', geb_datum, ':', sep='')
            if geb_datum != 'None':
                geb_datum = geb_datum[8:10] + '.' + geb_datum[5:7] + '.' + geb_datum[0:4]
            else:
                geb_datum = ''
            print('geb_datum:', geb_datum, ':', sep='')
            eMail_adr = worksheet_sheet["G" + str(row)].value
            str_hNr_Ort = worksheet_sheet["E" + str(row)].value
            str_hNr_Ort = str_hNr_Ort.replace('  ', ' ')
            # print('str_hNr_Ort:', str_hNr_Ort)
            if ', ' in str_hNr_Ort:
                str_nr, plz_ort = str_hNr_Ort.split(', ')
            else:
                str_nr = str_hNr_Ort.replace('  ', ' ')
                plz_ort = '8855 Wangen'

            # print('str_nr:', str_nr, ':', sep='')
            str_hsNr_parts = []
            str_hsNr_parts = str_nr.split(' ')
            strasse = ' '.join(str_hsNr_parts[:-1])
            hausnr = str_hsNr_parts[-1]
            print('strasse:', strasse, ':', sep='')
            print('hausnr:' + hausnr, ':', sep='')

            print('eMail_adr:', eMail_adr, ':', sep='')
            # print('plz_ort:', plz_ort, ':', sep='')
            plz, ort = plz_ort.split(' ')
            print('plz:', plz, ':', sep='')
            print('ort:', ort, ':', sep='', end='\n\n')

            args = ('Loader_1', sex, '', Vorname, Nachname_2, Nachname, False, strasse, hausnr, plz, ort, 'x')
            print('    getPersonenId', str(args), sep='')
            myCursor = stammdaten_schema.cursor()
            result_args = myCursor.callproc('getPersonenId', args)
            print(result_args[-1])
            worksheet_sheet["A" + str(row)].value = str(result_args[-1])
            halt('Insert?')
        row += 1
    workbook.save(excel_file)
    workbook.close()



