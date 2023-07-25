#!/usr/bin/python3

# --------------------------------
# Name  : Genossame_Common_Defs.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Genossame_Manager/Genossame_Common_Defs
#
# Description: Common Definitions for Genossame-Daten
#
# Autor: Walter Rothlin
#
# History:
# 21-Jun-2023   Walter Rothlin      Initial Version
# --------------------------------
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


# Common DB-Functions
# ===================
def do_db_connect(db_host='localhost', port=3306, db_schema='stammdaten', db_user_name=None, password=None, trace=False):
    if trace:
        print(f"Connecting to '{db_schema:s}@{db_host:s}' with user '{db_user_name:s}'....", end="", flush=True)
    db_connection = mysql.connector.connect(
          host        = db_host,
          port        = port,
          user        = db_user_name,
          password    = password,
          database    = db_schema,
          auth_plugin = 'mysql_native_password'
    )
    if trace:
        print("completed!")
    return db_connection


def db_connect(connect_to_prod=True, trace=False):
    if connect_to_prod:
        stammdaten_schema = do_db_connect(db_host='192.168.253.24',
                                       port=3311,
                                       db_schema='genossame_wangen',
                                       db_user_name="Web_App_User",
                                       password="Geno_8855!",
                                       trace=trace)
    else:
        stammdaten_schema = do_db_connect(db_host='localhost',
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


# Static DB-Functions
# ===================
def execute_important_sql_queries(db, verbal=False):
    myCursor = db.cursor()
    if verbal:
        print('Calling stored-proc important updates...', end='')
    args = ()
    result_args = myCursor.callproc('important_updates', args)
    if verbal:
        print('done')

def get_record_count(db=None, db_tbl_name=None, retValueWithTblName=True):
    sql_insert = f'SELECT count(*) FROM {db_tbl_name} '
    mycursor = db.cursor()
    mycursor.execute(sql_insert)
    myresult = mycursor.fetchall()
    if retValueWithTblName:
        return {'rows_in_db   (' + db_tbl_name + '):': myresult[0][0]}
    else:
        return myresult[0][0]

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


def update_if_neccessary(db_connection, tbl_name, id, field_name, field_value, verbal=False):
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
            sql_update = f"UPDATE {tbl_name} SET Vorwahl = '{field_value[0:3]}', Nummer = '{field_value[3:]}' WHERE id={id}"
            print(sql_update, end='\n\n')
            myCursor.execute(sql_update)
            db_connection.commit()
    return records_changed

# -------------------------------------------
# ++++++++++++ Main Main Main +++++++++++++++
# -------------------------------------------
if __name__ == '__main__':
    connect_to_prod = True
    AUTO_TEST__split_email_detailed_long(verbal=True)



