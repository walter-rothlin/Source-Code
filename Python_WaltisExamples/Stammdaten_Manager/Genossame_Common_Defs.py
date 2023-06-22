#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : Genossame_Common_Defs.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Genossame_Manager/Genossame_Common_Defs
#
# Description: Common Definitions for Genossame-Daten
#
# Autor: Walter Rothlin
#
# History:
# 21-Jun-2023   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
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
def do_db_connect(host='localhost', port=3306, schema='stammdaten', user=None, password=None, trace=False):
    if trace:
        print("Connecting to " + schema + "@" + host + "....", end="", flush=True)
    db_connection = mysql.connector.connect(
          host        = host,
          port        = port,
          user        = user,
          password    = password,
          database    = schema,
          auth_plugin = 'mysql_native_password'
    )
    if trace:
        print("completed!")
    return db_connection


def db_connect(connect_to_prod=True, trace=False):
    if connect_to_prod:
        stammdaten_schema = do_db_connect(host='192.168.253.24',
                                       port=3311,
                                       schema='genossame_wangen',
                                       user="root",
                                       password="Gen_88-mysql",
                                       trace=trace)
    else:
        stammdaten_schema = do_db_connect(host='localhost',
                                       schema='genossame_wangen',
                                       user="App_User_Stammdaten",
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


def execute_important_sql_queries(db_connection, verbal=False):
    myCursor = db_connection.cursor()
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
# -------------------------------------------
# ++++++++++++ Main Main Main +++++++++++++++
# -------------------------------------------
if __name__ == '__main__':
    connect_to_prod = True


