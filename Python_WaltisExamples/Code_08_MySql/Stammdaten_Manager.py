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

print("Connecting to Stammdaten-Schema....", end="", flush=True)
stammdaten_schema = mysql.connector.connect(
  host        = "localhost",
  user        = "App_User_Stammdaten",
  password    = "1234ABCD12abcd",
  database    = "stammdaten",
  auth_plugin = 'mysql_native_password'
)
print("completed!")


#  DATE_FORMAT(last_update, '%Y%m%d_%H%i%s')   AS Last_Update
def get_desc_from_view_or_table(tbl_or_view_name='Personen_Daten', sep=",\n", end="\n"):
    sql_stm_get_desc = 'Desc ' + tbl_or_view_name
    mycursor = stammdaten_schema.cursor(dictionary=True)
    mycursor.execute(sql_stm_get_desc)
    myresult = mycursor.fetchall()
    # print("Records found:", len(myresult), myresult)
    ret_str = ''
    for aDataSet in myresult:
      ret_str += aDataSet['Field'] + sep
    ret_str = ret_str[:-len(sep)]
    ret_str += end
    return ret_str

print(get_desc_from_view_or_table())
print(get_desc_from_view_or_table(sep=","))

sql_stm_select_Personen_Daten = """
    SELECT
      ID,
      Geschlecht,
      Anrede,
      Brief_Anrede,
      Firma,
      Vorname,
      Vorname_2,
      Vorname_Initial,
      Ledig_Name,
      Partner_Name,
      Partner_Name_Angenommen,
      Name,
      AHV_Nr,
      Betriebs_Nr,
      Zivilstand,
      Kategorien,
      IBAN,
      Tel_Nr,
      eMail,
      Geburtstag,
      Todestag,
      Nach_Wangen_Gezogen,
      Von_Wangen_Weggezogen,
      Baulandgesuch_Eingereicht_Am,
      Bauland_Gekauft_Am,
      Angemeldet_Am,
      Aufgenommen_Am,
      Funktion_Uebernommen_Am,
      Funktion_Abgegeben_Am,
      Chronik_Bezogen_Am,
      Private_Strasse,
      Private_Hausnummer,
      Private_PLZ,
      Private_PLZ_International,
      Private_Ort,
      Private_Land,
      Geschaeft_Strasse,
      Geschaeft_Hausnummer,
      Geschaeft_PLZ,
      Geschaeft_PLZ_International,
      Geschaeft_Ort,
      Geschaeft_Land,
      last_update
    FROM Personen_Daten
"""
mycursor = stammdaten_schema.cursor(dictionary=True)
mycursor.execute(sql_stm_select_Personen_Daten)
myresult = mycursor.fetchall()
print("\n\n")
print("Records found:", len(myresult), myresult)
for aDataSet in myresult:
  print(aDataSet['Private_PLZ'], ";",
        aDataSet['Private_Ort'], ";", sep="")
  print(aDataSet['Geschaeft_PLZ'], ";",
        aDataSet['Geschaeft_Ort'], ";", sep="")






