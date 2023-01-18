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

def put_data_in_table(db_connection,
                      tbl_name='ORTE',
                      values_as_JSON = {}):
    mycursor = db_connection.cursor()
    sql = "INSERT INTO " + tbl_name + "(`PLZ`, `Name`) VALUES ('3000', 'Bern')"
    print(sql)
    mycursor.execute(sql)

    # sql = "INSERT INTO " + tbl_name + "(`PLZ`, `Name`) VALUES (%s, %s)"
    # val = ("3000", "Bern")
    # mycursor.execute(sql, val)
    db_connection.commit()




if __name__ == '__main__':
    stammdaten_schema = db_connect(host='localhost',
                                   schema='stammdaten',
                                   user="App_User_Stammdaten",
                                   password="1234ABCD12abcd",
                                   trace=True)

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





