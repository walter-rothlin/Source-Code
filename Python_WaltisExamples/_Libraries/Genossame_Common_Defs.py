#!/usr/bin/python3

# ------------------------------------------------------------------------------------------------
# Name  : Genossame_Common_Defs.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Genossame_Manager/Genossame_Common_Defs
#
# Description: Common Definitions for Genossame-Daten
#
# Autor: Walter Rothlin
#
# History:
# 21-Jun-2023   Walter Rothlin      Initial Version
# 03-Sep-2023   Walter Rothlin      Reorganized library
# ------------------------------------------------------------------------------------------------
from waltisLibrary import *
import mysql.connector
import sqlparse
import csv
import json
import pandas as pd
import openpyxl

# Lambda function to check if a x is from WAHR / FALSCH.
ifTrue     = lambda x: True if (x == 'WAHR' or x == 'TRUE') else False
ifIntEmpty = lambda x: True if (x == '' or x == 'TRUE') else False


# =================
# Class Stammdaten
# =================
class Stammdaten:
    def __init__(self):
        self.__db_connection = db_connect(connect_to_prod=True, trace=True)


    def get_version(self):
        return("V1.0.0.0")

    def get_person_details_from_DB_by_ID(self, id=None, search_criterium=None, attr_list=['*']):
        fieldStr = (',\n            ').join(attr_list)

        if id is None:
            if search_criterium is None:
                sql = """
                    SELECT
                        """ + fieldStr + """
                    FROM Personen_Daten
                    Limit 0,20;
                """
            else:
                sql = """
                    SELECT
                        """ + fieldStr + """
                    FROM Personen_Daten
                    WHERE Such_Begriff LIKE '%""" + search_criterium + """%';
                """
        else:
            sql = """
            SELECT
                """ + fieldStr + """
            FROM Personen_Daten 
            WHERE ID = """ + str(id) + """;
            """
        print(sql)
        mycursor = self.__db_connection.cursor(dictionary=True)
        mycursor.execute(sql)
        return mycursor.fetchall()


# =================
# Geno DB-Functions
# =================
def db_connect(connect_to_prod=True, trace=False):
    if connect_to_prod:
        stammdaten_schema = mysql_db_connect(db_host='192.168.253.24',
                                             port=3311,
                                             db_schema='genossame_wangen',
                                             db_user_name="Web_App_User",
                                             password="Geno_8855!",
                                             trace=trace)
    else:
        stammdaten_schema = mysql_db_connect(db_host='localhost',
                                             db_schema='genossame_wangen',
                                             db_user_name="App_User_Stammdaten",
                                             password="1234ABCD12abcd",
                                             trace=trace)
    return stammdaten_schema


def get_personen_ids(db_connection, such_kriterien, verbal=False, db_table='personen_daten', search_attr='Such_Begriff', select_attributes=['ID', 'Vorname_Initial', 'Familien_Name', 'Private_Strassen_Adresse', 'Private_PLZ_Ort']):
    verbal = False
    myCursor = db_connection.cursor()

    prep_such_kriterien = []
    for a_such_kriterium in such_kriterien:
        a_such_kriterium.replace(' - ', '-')
        split_liste = a_such_kriterium.split('-')
        for an_item in split_liste:
            prep_such_kriterien.append(an_item)

    if verbal:
        print('get_personen_id', str(prep_such_kriterien))

    where_clauses = []
    for a_such_kriterium in prep_such_kriterien:
        where_clauses.append(f"{search_attr} LIKE Binary '%{a_such_kriterium}%'")

    where_clause_str = ' AND\n                  '.join(where_clauses)
    if False:
        print(where_clause_str)

    select_person = f"""
            SELECT 
               {','.join(select_attributes)}
            FROM {db_table} 
            WHERE {where_clause_str};
    """
    if verbal:
        print(select_person)

    myCursor.execute(select_person)
    result_set = myCursor.fetchall()
    if verbal:
        print(result_set)

    if len(result_set) == 0 and len(such_kriterien) > 2:
        # input('recorsive search?')
        result_set = get_personen_ids(db_connection, such_kriterien[:-1], verbal=verbal, db_table=db_table, search_attr=search_attr, select_attributes=select_attributes)


    if len(result_set) > 1:
        print('Multiple found')
        # input('weiter?')
    return result_set


def get_personen_id(db_connection, such_kriterien, verbal=False):
    myresult = get_personen_ids(db_connection, such_kriterien, verbal=verbal)

    pers_id = None
    if verbal:
        print("Records found:", len(myresult), myresult, '\n')
    if myresult == 1:
        pers_id = myresult[0][0]
    return pers_id


def execute_important_sql_queries(db, verbal=False):
    myCursor = db.cursor()
    if verbal:
        print('Calling stored-proc important updates...', end='')
    args = ()
    result_args = myCursor.callproc('important_updates', args)
    if verbal:
        print('done')

def addPersonen_to_db_by_hash(db, arguments, take_action=False, verbal=False):
    if verbal:
        print(f'''
           --> Calling addPersonen_to_db_by_hash(db,
                                    arguments               = {arguments}, 
                                    take_action             = {take_action},
                                    verbal                  = {verbal})''')
    pers_id = None
    if take_action:
        pers_id = addPersonen_to_db(db,
                                 arguments['Source'],
                                 arguments['Vorname'],
                                 arguments['Ledig_Name'],
                                 arguments['Partner_Name'],
                                 arguments['Partner_Name_Angenommen'],
                                 arguments['Private_Adressen_ID'],
                                 take_action=take_action,
                                 verbal=verbal)
    return pers_id


def addPersonen_to_db(db, source, vorname, ledig_name, partner_name, partner_name_angenommen, privat_adressen_id, take_action=False, verbal=False):
    try:
        if verbal:
            print(f'''
               --> Calling addPersonen_to_db(db,
                                        source                  = {source}, 
                                        vorname                 = {vorname},
                                        ledig_name              = {ledig_name},
                                        partner_name            = {partner_name},
                                        partner_name_angenommen = {partner_name_angenommen},
                                        privat_adressen_id      = {privat_adressen_id},
                                        take_action             = {take_action},
                                        verbal                  = {verbal})''')

        pers_id = None

        if take_action:
            myCursor = db.cursor()
            args = (source, vorname, ledig_name, partner_name, partner_name_angenommen, privat_adressen_id, 'x')
            result_args = myCursor.callproc('addPersonen', args)
            db.commit()
            if verbal:
                print(f'callproc:addPersonen{args}')
                print(f'        :return value{result_args}')
            pers_id = result_args[-1]

        return pers_id

    except mysql.connector.Error as err:
        print(f"Error: {err}")
        return None
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        return None

def get_db_attr_type(db, table, attribute, take_action=False, verbal=False):
    if verbal:
        print(f'''
           --> Calling get_db_attr_type(db,
                                    table                  = {table}, 
                                    attribute              = {attribute},
                                    take_action            = {take_action},
                                    verbal                 = {verbal})''')

    sql_insert = f"SELECT Attr_Type,Enum_Set_Values FROM Table_Meta_data WHERE `Table` = '{table}' AND `Attribute` = '{attribute}'"
    if verbal:
        print(sql_insert)
    mycursor = db.cursor()
    mycursor.execute(sql_insert)
    ret_val = {}
    for aRec in mycursor.fetchall():
        ret_val = {
            'type' : aRec[0].decode('ascii'),
            'enums': ''  # aRec[1]    # .decode('ascii')
        }
    return ret_val


# email functions
# ---------------
def get_email_ids_for_persid(db, pers_id, verbal=False):
    ret_list = []
    sql_insert = f'SELECT EMail_adressen_ID FROM personen_has_email_adressen WHERE Personen_ID = {pers_id} '
    mycursor = db.cursor()
    mycursor.execute(sql_insert)
    for aId in mycursor.fetchall():
        ret_list.append(str(aId[0]))
    return ret_list

def get_email_details_for_ids(db, email_ids, verbal=False):
    email_ids_where_clause = ', '.join(email_ids)
    sql_insert = f'SELECT ID, eMail, Type, Prio FROM email_adressen WHERE ID in ({email_ids_where_clause}) ORDER BY Prio'
    mycursor = db.cursor(dictionary=True)
    mycursor.execute(sql_insert)
    return mycursor.fetchall()

def get_email_details_persid(db, pers_id, verbal=False):
    email_ids = get_email_ids_for_persid(db, pers_id, verbal=verbal)
    return get_email_details_for_ids(db, email_ids, verbal=verbal)

def fix_email_details_persid(db, pers_id, verbal=False):
    email_details = get_email_details_persid(db, pers_id, verbal=verbal)
    last_prio = 0
    for a_eMail_details in email_details:
        a_eMail_details['eMail'] = a_eMail_details['eMail'].lower().replace(' ', '')
        a_eMail_details['Prio'] = last_prio
        last_prio += 1
    print(email_details)

def split_email_detailed_long(detailed_long_str, verbal=False, email_only=False):
    if verbal:
        print(f" called .... split_email_detailed_long('{detailed_long_str}', '{verbal}')")
    detailed_long_str = detailed_long_str.replace(' ', '')
    detailed_list = detailed_long_str.split(':')
    if len(detailed_list) > 1:
        if verbal:
            print(detailed_list)
        ret_value = {'ID': detailed_list[0],
                     'eMail': detailed_list[0],
                     'Type': detailed_list[2],
                     'Prio': detailed_list[1],
                     }
    else:
        ret_value = {'eMail': detailed_list[0]}

    if email_only:
        ret_value = ret_value['eMail']
    return ret_value

def AUTO_TEST__split_email_detailed_long(verbal=True):
    print('\n\n==> AUTO_TEST__split_email_detailed_long.....\n')
    print('1) ', split_email_detailed_long('walter@rothlin.com  :321:  0:Sonstige:', verbal=verbal), '\n' + generateStringRepeats(10, '----'))
    print('2) ', split_email_detailed_long('walter.rothlin@fh-hwz.ch  :320:  1:Geschaeft:', verbal=verbal), '\n' + generateStringRepeats(10, '----'))
    print('3) ', split_email_detailed_long('walterrr@rothlin.com', verbal=verbal), '\n' + generateStringRepeats(10, '----'))
    print('\n\n... AUTO_TEST__split_email_detailed_long Done!!\n')


# div  functions
# ---------------
def update_or_insert_value(db_connection, pers_id, attribute_name, value, verbal=False):
    count_of_inserts = 0
    count_of_updates = 0
    count_of_matches = 0
    myCursor = db_connection.cursor()
    if verbal:
        print(f"update_or_insert_value({pers_id}, '{attribute_name}', '{value}', {verbal})")
    if attribute_name == 'eMai_adressen':
        sql_select = f'SELECT eMail_adresse, Type, Prio FROM email_liste WHERE Pers_ID={pers_id}'
        myCursor.execute(sql_select)
        myresult = myCursor.fetchall()
        if len(myresult) == 0:
            print(f"add_email({pers_id}, {value['eMail'].lower()})")
            args = (pers_id, value['eMail'].lower(), 'Sonstige', 0, 'x')  # 'x' in the Tuple will be replaced by OUT-Value
            if verbal:
                print('    addEmailAdr', str(args), sep='')
            result_args = myCursor.callproc('addEmailAdr', args)
            count_of_inserts += 1
        else:
            for a_email_adr in myresult:
                if a_email_adr[0].lower() == value['eMail'].lower():
                    if verbal:
                        print('Matches: ', a_email_adr[0], value['eMail'])
                    count_of_matches += 1
                    break
                else:
                    print(f'{pers_id:4s}   DB:', a_email_adr[0])
                    print('New_Value:', value['eMail'], '\n')
                    current_emails = get_email_ids_for_persid(db_connection, pers_id)
                    if len(current_emails) == 1:
                        old_email_details = get_email_details_for_ids(db_connection, current_emails)[0]
                        sql_del = f'DELETE FROM personen_has_email_adressen WHERE Personen_ID={pers_id} AND EMail_adressen_ID={old_email_details[0]}'
                        print(old_email_details)
                        print('sql_del:', sql_del)
                        myCursor = db_connection.cursor()
                        myCursor.execute(sql_del)
                        db_connection.commit()

    if attribute_name == 'telefon_nummer':
        sql_select = f'SELECT Tel_Nr, Type, Endgeraet, Prio FROM Telnr_liste WHERE Pers_ID={pers_id}'
        myCursor.execute(sql_select)
        myresult = myCursor.fetchall()
        value['tel_nr'] = value['tel_nr'].replace(' ', '')
        if len(myresult) == 0:
            print(f"addTelNr({pers_id}, {value['tel_nr']})")
            vorwahl = value['tel_nr'][0:3]
            telnr = value['tel_nr'][3:]
            if vorwahl == '055':
                endgeraet = 'Festnetz'
            else:
                endgeraet = 'Mobile'
            args = (pers_id, '0041', vorwahl, telnr, 'Sonstige', endgeraet, 0, 'x')
            if verbal:
                print('    addTelNr', str(args), sep='')
            result_args = myCursor.callproc('addTelNr', args)
            count_of_inserts += 1
        else:
            for a_telnr in myresult:
                if verbal:
                    print('FromDB  :', a_telnr)
                    print('FromParm:', value)
                if a_telnr[0].replace(' ', '') == value['tel_nr'].replace(' ', ''):
                    if verbal:
                        print('Matches: ', a_telnr[0], value['tel_nr'])
                    count_of_matches += 1
                    break
                else:
                    print(f'{pers_id:4s}   DB:', a_telnr[0])
                    print('New_Value:', value['tel_nr'], '\n')
                    if verbal:
                        input('weiter_3')

    if attribute_name == 'Geburtstag' or attribute_name == 'Newsletter_Abonniert_Am':
        a_date = str(value['Date'])
        # print('a_date         :', a_date)
        dd = a_date[8:10]
        mm = a_date[5:7]
        yyyy = a_date[:4]
        a_date = dd + '.' + mm + '.' + yyyy
        # print('a_date         :', a_date, '\n\n')

        sql_select = f"SELECT DATE_FORMAT({attribute_name},'%d.%m.%Y') FROM Personen WHERE ID={pers_id}"
        # print(sql_select)
        myCursor.execute(sql_select)
        myresult = myCursor.fetchall()
        # print(myresult)
        a_date_from_db = myresult[0][0]
        if verbal:
            print('FromDB  :', a_date_from_db)
            print('FromParm:', a_date)
        if myresult[0][0] == a_date:
            if verbal:
                print('Match Date: ', a_date_from_db, a_date)
            count_of_matches += 1
        else:
            sql_update = f"Update Personen SET {attribute_name} = STR_TO_DATE('{a_date}','%d.%m.%Y') WHERE ID={pers_id}"
            myCursor.execute(sql_update)
            count_of_updates += myCursor.rowcount
            db_connection.commit()
            if verbal:
                print(f'{pers_id:4s}   DB:', a_date_from_db)
                print('New_Value:', a_date, '\n')
                print('sql_select:', sql_update)
                input('weiter_4')

    return {'count_of_inserts': count_of_inserts,
            'count_of_updates': count_of_updates,
            'count_of_matches': count_of_matches}

def TEST_update_or_insert_value(db_connection):
    test_value = {'eMail': 'walter@Rothlin.com'}
    print(update_or_insert_value(db_connection, '644', 'eMai_adressen', test_value, verbal=True))
    test_value = {'eMail': 'walterr@Rothlin.com'}
    print(update_or_insert_value(db_connection, '223', 'eMai_adressen', test_value, verbal=True))





# ---------------------------------------------
# Functions for Common use
# ---------------------------------------------
def process_CUD(stammdaten_schema, reco_data_fn, reco_sheetname, verbal=False, take_action=False):
    if verbal:
        print(f'''
           --> Calling process_CUD(stammdaten_schema,
                                    {reco_data_fn}, 
                                    {reco_sheetname}, 
                                    verbal={verbal}, 
                                    take_action={take_action})''')

        print(f'Open Excel:{reco_data_fn} [{reco_sheetname}]')

    # Open and read the Excel
    # -----------------------
    workbook = openpyxl.load_workbook(reco_data_fn, data_only=True)
    worksheet_sheet = workbook[reco_sheetname]

    verbal_while_insert = False
    verbal_while_update = verbal
    count_of_new_records = 0
    count_of_updated_records = 0
    count_of_updated_attributs = 0
    count_of_total_lines = 0

    """      
       -- FK: Verwandschaft
      `Partner_ID` 		                   INT NULL,
      `Vater_ID`         		           INT NULL,
      `Mutter_ID`				           INT NULL,
      
      -- FK: Adressen
      `Privat_Adressen_ID`                 INT UNSIGNED NULL,
      `Geschaefts_Adressen_ID`             INT UNSIGNED NULL,
    """


    """
    Private_Adressen_ID	
    Private_Strasse	
    Private_Hausnummer	
    Private_Postfachnummer	
    Private_Ort_ID	
    Private_PLZ	
    Private_Ort	
    Private_Land_ID	
    Private_Land	

    
    Tel_Nr_Detail_Long	
    Tel_Nr_1_Detail_Long	
    Tel_Nr_2_Detail_Long	
    	
    eMail_1_Detail_Long	
    eMail_2_Detail_Long	
    IBAN_Detail_Long

    
    
    Geschaeft_Adressen_ID	
    Geschaeft_Strasse	
    Geschaeft_Hausnummer	
    Geschaeft_Postfachnummer	
    Geschaeft_Ort_ID	
    Geschaeft_PLZ	
    Geschaeft_Ort	
    Geschaeft_Land_ID	
    Geschaeft_Land    
    """

    db_attr_excel_column_mapping = [
        {'excel': 'Source'},
        {'excel': 'History'},
        {'excel': 'Bemerkungen'},
        {'excel': 'Zivilstand'},
        {'excel': 'Kategorien'},
        {'excel': 'Funktion'},
        {'excel': 'Firma'},

        {'db': 'Sex',
         'excel': 'Geschlecht'},
        {'excel': 'Vorname'},
        {'excel': 'Vorname_2'},
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

        # Dates
        # -----
        {'excel': 'Geburtstag'},
        {'excel': 'Geburtstag'},
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

        {'excel': 'eMail_Detail_Long',
         'db': 'Join'},
        {'excel': 'eMail_1_Detail_Long',
         'db': 'Join'},
        {'excel': 'eMail_2_Detail_Long',
         'db': 'Join'},
    ]

    title_row = 1
    first_value_row = 2
    row = first_value_row
    while worksheet_sheet["A" + str(row)].value is not None:
        count_of_total_lines += 1
        pers_id = get_cell_value_by_column_title(worksheet_sheet, title_row=title_row, row=row, column_name='ID', verbal=False)['ID']

        if pers_id == '?':
            verbal = False
            print('--> A New Person')
            count_of_new_records += 1
            values = get_cell_values_by_column_titles(
                             worksheet_sheet,
                             title_row        = title_row,
                             row              = row,
                             column_names     = ['Vorname', 'Ledig_Name', 'Partner_Name', 'Partner_Name_Angenommen', 'Private_Adressen_ID'],
                             do_reset_cell    = take_action,
                             reset_cell_value = '',
                             take_action      = take_action,
                             verbal           = verbal_while_insert)
            values['Source'] = 'Loader_1'
            ret_val   = addPersonen_to_db_by_hash(stammdaten_schema, values, take_action=take_action, verbal=verbal_while_insert)
            ret_val_1 = set_cell_value_by_column_title(ret_val, worksheet_sheet, title_row=1, row=row, column_name='ID', take_action=take_action, verbal=verbal_while_insert)
            if verbal:
                print(ret_val, ret_val_1)

        else:
            if verbal_while_update:


                if pers_id == 1172:
                    print('-->', pers_id, 'Update Person details')

                    db_table_name     = 'Personen'
                    for a_mapping in db_attr_excel_column_mapping:
                        if a_mapping.get('db') is not None:
                            db_attr_name = a_mapping['db']
                        else:
                            db_attr_name = a_mapping['excel']

                        if a_mapping.get('excel') is not None:
                            excel_column_name = a_mapping['excel']
                        else:
                            excel_column_name = a_mapping['db']
                        # print('db_attr_name:', db_attr_name, '    excel_column_name:', excel_column_name)
                        # halt()

                        values = get_cell_values_by_column_titles(
                            worksheet_sheet,
                            title_row=title_row,
                            row=row,
                            column_names=[excel_column_name],
                            do_reset_cell=take_action,
                            reset_cell_value='',
                            take_action=take_action,
                            verbal=verbal_while_update)
                        new_value_from_excel = values[excel_column_name]
                        if new_value_from_excel is None or new_value_from_excel == '':
                            if verbal_while_update:
                                print(pers_id, 'No update for', excel_column_name)
                        else:
                            if (db_attr_name == 'Join'):
                                print("JOIN    .... ", excel_column_name, new_value_from_excel)

                            else:
                                attr_type = get_db_attr_type(stammdaten_schema, table=db_table_name, attribute=db_attr_name, take_action=take_action, verbal=verbal_while_update)
                                count_of_updated_attributs += update_db_attribute(stammdaten_schema,
                                        db_tbl_name=db_table_name, db_attr_name=db_attr_name, db_attr_type=attr_type['type'], db_attr_set_enum_values=attr_type['enums'],
                                        id_attr_name='ID', id=pers_id,
                                        new_value=new_value_from_excel, new_value_format=None,
                                        take_action=take_action, verbal=verbal_while_update)
                count_of_updated_records += 1
        row += 1

    # Save the Excel
    # --------------
    if take_action:
        if verbal:
            print(f'Close Excel:{reco_data_fn} [{reco_sheetname}]')
        workbook.save(reco_data_fn)
        workbook.close()


    print(f'''
    # Statistics
    # ==========
    Changes Found in File: {count_of_total_lines:4d}
          Inserted Reords: {count_of_new_records:4d}
          Updated Records: {count_of_updated_records:4d}
      
        Updated Attributs: {count_of_updated_attributs:4d}
    ''')
# ---------------------------------------------
# END: Functions for Common use
# ---------------------------------------------



def update_if_neccessary(db_connection, tbl_name, id, field_name, field_value, verbal=True, take_action=False):

    if verbal:
        print(f'''
           --> Calling update_if_neccessary(db_connection,
                                                  {tbl_name}, 
                                                  {id},
                                                  {field_name},
                                                  verbal={verbal}, 
                                                  take_action={take_action})''')
    verbal = False
    myCursor = db_connection.cursor()
    records_changed = 0
    if verbal:
        print(tbl_name, id, field_name, field_value)

    if tbl_name == 'email_adressen' or tbl_name == 'iban':
        sql_select = f'SELECT {field_name} FROM {tbl_name} WHERE id={id}'
        myCursor.execute(sql_select)
        myresult = myCursor.fetchall()
        old_value = myresult[0][0].replace(' ', '')
        if field_value != old_value:
            records_changed = 1
            print(tbl_name, '::  old: ', old_value, '   new:', field_value, '  id:', id)
            sql_update = f"UPDATE {tbl_name} SET {field_name} = '{field_value}' WHERE id={id}"
            print(sql_update, end='\n\n')
            if take_action:
                myCursor.execute(sql_update)
                db_connection.commit()
    if tbl_name == 'telefonnummern':
        sql_select = f'SELECT vorwahl,{field_name} FROM {tbl_name} WHERE id={id}'
        myCursor.execute(sql_select)
        myresult = myCursor.fetchall()
        old_nummer = myresult[0][1]
        old_nummervorwahl = myresult[0][0]
        if old_nummervorwahl + old_nummer != field_value:
            records_changed = 1
            print(tbl_name, '::  old: ', old_nummervorwahl + old_nummer, '   new:', field_value)
            if field_value == 'keine':
                sql_update = f"UPDATE {tbl_name} SET Vorwahl = '', Nummer = '{field_value}' WHERE id={id}"
            else:
                sql_update = f"UPDATE {tbl_name} SET Vorwahl = '{field_value[0:3]}', Nummer = '{field_value[3:]}' WHERE id={id}"
            print(sql_update, end='\n\n')
            if take_action:
                myCursor.execute(sql_update)
                db_connection.commit()
    return records_changed



# -------------------------------------------------------------------
# ++++++++++++ Alte, nicht mehr gebrauchte Funktionen +++++++++++++++
# -------------------------------------------------------------------
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


# -------------------------------------------
# ++++++++++++ Main Main Main +++++++++++++++
# -------------------------------------------
if __name__ == '__main__':
    connect_to_prod = True
    AUTO_TEST__split_email_detailed_long(verbal=True)



