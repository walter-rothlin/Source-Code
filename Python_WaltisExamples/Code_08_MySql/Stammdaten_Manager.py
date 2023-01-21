#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Stammdaten_Manager.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_08_MySql/Stammdaten_Manager.py
#
# Description: Manager für Stammdaten
#
# Autor: Walter Rothlin
#
# History:
# 24-Jun-2022   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
import mysql.connector
import sqlparse
import csv
import json

def db_connect(host='localhost', schema='stammdaten', user=None, password=None, trace=False):
    if trace:
        print("Connecting to " + schema + "@" + host + "....", end="", flush=True)
    db_connection = mysql.connector.connect(
          host        = host,
          user        = user,
          password    = password,
          database    = schema,
          auth_plugin = 'mysql_native_password'
    )
    if trace:
        print("completed!")
    return db_connection


#  DATE_FORMAT(last_update, '%Y%m%d_%H%i%s')   AS Last_Update
def get_fields_from_view_or_table_as_list(db_connection, tbl_or_view_name='Personen_Daten', return_as_list=True, sep=",\n", end="\n"):
    sql_stm_get_desc = 'Desc ' + tbl_or_view_name
    mycursor = db_connection.cursor(dictionary=True)
    mycursor.execute(sql_stm_get_desc)
    myresult = mycursor.fetchall()

    if return_as_list:
        ret_value = []
        for aDataSet in myresult:
            ret_value.append(aDataSet['Field'])
    else:
        ret_value = ''
        for aDataSet in myresult:
            ret_value += aDataSet['Field'] + sep
        ret_value = ret_value[:-len(sep)]
        ret_value += end
    return ret_value

def get_data_from_view_or_table(db_connection,
                                tbl_or_view_name='Personen_Daten',
                                fields_to_select=None,
                                where_clause=None,
                                sort_criteria=None,
                                result_as='CSV',  # JSON CSV
                                sep=";",
                                end="\n",
                                trace=False):
    if fields_to_select is None:
        fields_to_select = get_fields_from_view_or_table_as_list(db_connection, tbl_or_view_name=tbl_or_view_name)

    field_as_string = ','.join(fields_to_select)
    header_string = sep.join(fields_to_select)
    sql_stm_select_from_tbl_or_view = "SELECT " + field_as_string + " FROM " + tbl_or_view_name
    if where_clause is not None:
        sql_stm_select_from_tbl_or_view += " WHERE " + where_clause
    if sort_criteria is not None:
        sql_stm_select_from_tbl_or_view += " ORDER BY " + sort_criteria

    sql_formatted = sqlparse.format(sql_stm_select_from_tbl_or_view, reindent=True, keyword_case='upper')

    if trace:
        print(sql_formatted)
    mycursor = stammdaten_schema.cursor(dictionary=True)
    mycursor.execute(sql_formatted)
    myresult = mycursor.fetchall()

    if result_as == 'CSV':
        ret_str = header_string + end
        for aDataSet in myresult:
            value_list = []
            for anAttr in fields_to_select:
                value_list.append(str(aDataSet[anAttr]))
            ret_str += sep.join(value_list)
            ret_str += end
        return ret_str
    else:
        return myresult

def csv_to_json(csvFilePath, delimiter=',', jsonFilePath=None):
    jsonArray = []

    # read csv file
    with open(csvFilePath, encoding='utf-8') as csvf:
        # load csv file data using csv library's dictionary reader
        # csvReader = csv.DictReader(csvf, delimiter=delimiter, quoting=csv.QUOTE_NONE)
        csvReader = csv.DictReader(csvf)


        # convert each csv row into python dict
        for row in csvReader:
            # add this python dict to json array
            jsonArray.append(row)

    # convert python jsonArray to JSON String and write to file
    if jsonFilePath is not None:
        with open(jsonFilePath, 'w', encoding='utf-8') as jsonf:
            jsonString = json.dumps(jsonArray, indent=4)
            jsonf.write(jsonString)

    return jsonArray

def read_from_file_and_call_stored_procedure(
        db_connection,
        csv_file_name=r'N:\02_EDV\Orte_Import.csv',
        csv_delimiter=';',   # Not functioning yet (file has to be separated by ,
        proc_name='getOrtId',
        db_file_mapping={'PLZ': 'PLZ', 'Name': 'Ortsname', 'Kanton': 'Kanton', 'TelVorwahl': 'Tel_Vorwahl'}):

    mycursor = stammdaten_schema.cursor()
    input_csv_json = csv_to_json(csv_file_name, delimiter=',')
    # print(input_csv_json)

    # print('db_file_mapping:', db_file_mapping)
    requested_attributs = db_file_mapping.keys()
    arg_counts=len(requested_attributs)
    # print('requested_attributs:', requested_attributs)

    print(proc_name, ":", len(input_csv_json))
    for a_data_tuple in input_csv_json:
        # print('-->', a_data_tuple)
        values = []
        for a_attribute in requested_attributs:
            values.append(a_data_tuple[db_file_mapping[a_attribute]])
            # print('==>', a_attribute, a_data_tuple[db_file_mapping[a_attribute]])
        # print(','.join(requested_attributs), ' --> ', ','.join(values))

        if arg_counts == 0:
            args = ('x')
        elif arg_counts == 1:
            args = (values[0], 'x')
        elif arg_counts == 2:
            args = (values[0], values[1], 'x')
        elif arg_counts == 3:
            args = (values[0], values[1], values[2], 'x')
        elif arg_counts == 4:
            args = (values[0], values[1], values[2], values[3], 'x')
        elif arg_counts == 5:
            args = (values[0], values[1], values[2], values[3], values[4], 'x')
        elif arg_counts == 6:
            args = (values[0], values[1], values[2], values[3], values[4], values[5], 'x')
        elif arg_counts == 7:
            args = (values[0], values[1], values[2], values[3], values[4], values[5], values[6], 'x')
        elif arg_counts == 8:
            args = (values[0], values[1], values[2], values[3], values[4], values[5], values[6], values[7], 'x')
        elif arg_counts == 9:
            args = (values[0], values[1], values[2], values[3], values[4], values[5], values[6], values[7], values[8], 'x')
        elif arg_counts == 10:
            if proc_name == 'getPersonenId':
                if values[5] == 'Ja':
                    Name_Angenommen = True
                else:
                    Name_Angenommen = False

                args = ('BuergerDB', values[0], values[1], values[2], values[3], values[4], Name_Angenommen, values[6], values[7], values[8], values[9], 'x')
        elif arg_counts == 11:
            args = (values[0], values[1], values[2], values[3], values[4], values[5], values[6], values[7], values[8], values[9], values[10], 'x')
        else:
            print("ERROR: arg_counts ", arg_counts, " NOT defined")
        print(proc_name, args, sep="", end="  -->  ")
        result_args = mycursor.callproc(proc_name, args)
        print(proc_name, result_args, sep="")
        if proc_name == 'getPersonenId':
            personen_id = result_args[11]

            # Update Personen
            datGeburtstag = a_data_tuple['datGeburtstag']
            if datGeburtstag != "":
                datGeburtstag = "Geburtstag=str_to_date('" + a_data_tuple['datGeburtstag'] + "','%d.%m.%Y')"
            else:
                datGeburtstag = "Geburtstag=NULL"
            # print('datGeburtstag:', datGeburtstag)

            datGestorben = a_data_tuple['datGestorben']
            if datGestorben != "":
                datGestorben = "Todestag=str_to_date('" + a_data_tuple['datGestorben'] + "','%d.%m.%Y')"
            else:
                datGestorben = "Todestag=NULL"
            # print('datGestorben:', datGestorben)

            sql = "UPDATE Personen SET " + datGeburtstag + "," + datGestorben + " WHERE id = " + str(personen_id)
            # print(sql)
            mycursor.execute(sql)
            db_connection.commit()

            # Update Adressen
            postfach = a_data_tuple['strPostfach']
            if postfach != "":
                # print(str(personen_id) + ":Postfach:" + postfach)
                sql = "UPDATE ADRESSEN SET Postfachnummer = " + postfach + " WHERE id=(SELECT Privat_Adressen_id from Personen where id=" + str(personen_id) + ")"
                # print(sql)
                mycursor.execute(sql)
                db_connection.commit()

            # Update Telefonnummer
            prio = 0
            telnr_ids = []
            if a_data_tuple['strTelefon_Privat1'] != "":
                args = ('0041', '', a_data_tuple['strTelefon_Privat1'], 'Privat', 'Festnetz', prio, 'x')
                result_args = mycursor.callproc('getTelefonnummerId', args)
                telnr_ids.append(result_args[6])
                prio += 1

            if a_data_tuple['strTelefon_Privat2'] != "":
                args = ('0041', '', a_data_tuple['strTelefon_Privat2'], 'Privat', 'Festnetz', prio, 'x')
                result_args = mycursor.callproc('getTelefonnummerId', args)
                telnr_ids.append(result_args[6])
                prio += 1

            if a_data_tuple['strTelefon_Geschäft1'] != "":
                args = ('0041', '', a_data_tuple['strTelefon_Geschäft1'], 'Geschaeft', 'Festnetz', prio, 'x')
                result_args = mycursor.callproc('getTelefonnummerId', args)
                telnr_ids.append(result_args[6])
                prio += 1

            if a_data_tuple['strTelefon_Geschäft2'] != "":
                args = ('0041', '', a_data_tuple['strTelefon_Geschäft2'], 'Geschaeft', 'Festnetz', prio, 'x')
                result_args = mycursor.callproc('getTelefonnummerId', args)
                telnr_ids.append(result_args[6])
                prio += 1

            if a_data_tuple['strMobil_Telefon'] != "":
                args = ('0041', '', a_data_tuple['strMobil_Telefon'], 'Privat', 'Mobile', prio, 'x')
                result_args = mycursor.callproc('getTelefonnummerId', args)
                telnr_ids.append(result_args[6])
                prio += 1

            if a_data_tuple['strFaxnummer_Privat'] != "":
                args = ('0041', '', a_data_tuple['strFaxnummer_Privat'], 'Privat', 'FAX', prio, 'x')
                result_args = mycursor.callproc('getTelefonnummerId', args)
                telnr_ids.append(result_args[6])
                prio += 1

            if a_data_tuple['strFaxnummer_Geschäft'] != "":
                args = ('0041', '', a_data_tuple['strFaxnummer_Geschäft'], 'Geschaeft', 'FAX', prio, 'x')
                result_args = mycursor.callproc('getTelefonnummerId', args)
                telnr_ids.append(result_args[6])
                prio += 1

            print(personen_id, "TelIds:", telnr_ids)
            for aTelnNerId in telnr_ids:
                sql = "INSERT INTO Personen_has_telefonnummern (Personen_id, Telefonnummern_id) VALUES (" + str(personen_id) + "," + str(aTelnNerId) + ")"
                print(sql)
                mycursor.execute(sql)
                db_connection.commit()

    '''
    mycursor = db_connection.cursor()
    
    print(sql)
    mycursor.execute(sql)

    # "
    # val = ("3000", "Bern")
    # mycursor.execute(sql, val)
    
    '''





if __name__ == '__main__':
    stammdaten_schema = db_connect(host='localhost',
                                   schema='stammdaten',
                                   user="App_User_Stammdaten",
                                   password="1234ABCD12abcd",
                                   trace=True)


    read_from_file_and_call_stored_procedure(
        db_connection=stammdaten_schema,
        csv_file_name=r'N:\02_EDV\Land_Import.csv',
        csv_delimiter=',',
        proc_name='getLandId',
        db_file_mapping={'Name': 'Landname', 'Code': 'Code', 'Landesvorwahl': 'Landesvorwahl'})

    read_from_file_and_call_stored_procedure(
        db_connection=stammdaten_schema,
        csv_file_name=r'N:\02_EDV\Orte_Import.csv',
        csv_delimiter=',',
        proc_name='getOrtId',
        db_file_mapping={'PLZ': 'PLZ', 'Name': 'Ortsname', 'Kanton': 'Kanton', 'Tel_Vorwahl': 'TelVorwahl'})

    read_from_file_and_call_stored_procedure(
        db_connection=stammdaten_schema,
        csv_file_name=r'N:\02_EDV\Personen_Import.csv',
        csv_delimiter=',',
        proc_name='getPersonenId',
        db_file_mapping={'Sex': 'Sex', 'Firma': 'Firma', 'Vorname': 'Vorname', 'Ledig_Name': 'Ledig_Name', 'Partner_Name': 'Partner_Name', 'Partner_Name_Angenommen': 'Partner_Name_Angenommen', 'Strasse': 'Strasse', 'Hausnummer': 'Hausnummer', 'PLZ': 'PLZ', 'Ort': 'Ort'})



    '''
    print(get_data_from_view_or_table(stammdaten_schema))
    print('\n\n')
    print(get_data_from_view_or_table(stammdaten_schema,
                                      tbl_or_view_name='Personen_Daten',
                                      fields_to_select=['Firma', 'Vorname', 'Ledig_Name']))
    print('\n\n')
    print(get_data_from_view_or_table(stammdaten_schema,
                                      tbl_or_view_name='Personen_Daten',
                                      fields_to_select=['Firma', 'Vorname', 'Ledig_Name'],
                                      where_clause="Ledig_Name='Rothlin'",
                                      sort_criteria="Vorname",
                                      result_as='JSON',
                                      trace=True))

    put_data_in_table(stammdaten_schema)
    '''





