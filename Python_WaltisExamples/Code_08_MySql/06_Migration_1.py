#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 06_Migration_1.py
#
# Description: Migration the date after normalizing the schema
#               1) splitting 'strasse' into 'strasse' and 'hausnummer'
#               2) transfer 'PLZ' and 'ort' to table 'orte'
#               3) verifying data and change meta date via DDL
# Prepartion:
#
#
# Autor: Walter Rothlin
#
# History:
# 26-May-2020   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
import mysql.connector

print("Connecting to BZU....", end="", flush=True)
conn = mysql.connector.connect(
  host     = "localhost",
  user     = "root",
  passwd   = "admin",
  database = "BZU",
  auth_plugin = 'mysql_native_password'
)
print("completed!")

conn.autocommit = False
mycursor = conn.cursor()

doSplittingStrasse = True
print("\nMigrating Data: splitting 'strasse' into 'strasse' and 'hausnummer'")
if doSplittingStrasse:
    stm_selectAdressen = """
        SELECT
           adress_id  AS Id,
           vorname    AS Firstname,
           nachname   AS Lastname,
           strasse    AS Street,
           hausnummer AS Hausnummer,
           plz        AS PLZ,
           ort        AS City
        FROM 
           adressen
    """
    mycursor.execute(stm_selectAdressen)
    myresult = mycursor.fetchall()
    # print("Records found:", len(myresult), myresult)

    for aRec in myresult:
        strasseListe = aRec[3].split(' ')
        strasseStr = " ".join(strasseListe[:-1])
        hausnummer = strasseListe[-1]

        updateSQL = """   
                          UPDATE adressen SET 
                                 strasse='""" + strasseStr + """', 
                                 hausnummer='""" + hausnummer + """' 
                          WHERE adress_id = """ + str(aRec[0])
        print(updateSQL)
        mycursor.execute(updateSQL)
    conn.commit()
else:
    print("This step is disabled!\n")


doExportOrte = True
print("\nExporting 'PLZ' and 'Ort' from 'adressen' into 'orte'")
if doExportOrte:
    stm_exportOrte = """
        -- Move data into orte
        INSERT INTO orte (plz, name)
           SELECT DISTINCT
             plz,
             ort
           FROM 
             adressen
           ORDER BY plz, ort
    """
    print(stm_exportOrte)
    mycursor.execute(stm_exportOrte)
    conn.commit()
else:
    print("This step is disabled!\n")


doOrteReference = True
print("\nMigrating Data: refrencing orte via FK")
if doOrteReference:
    stm_selectOrte = """
        SELECT
           ort_id  AS Id,
           plz     AS PLZ,
           name    AS City
        FROM 
           orte
    """
    mycursor.execute(stm_selectOrte)
    myresult = mycursor.fetchall()
    # print("Records found:", len(myresult), myresult)
    for aRec in myresult:
        plzStr = str(aRec[1])
        ortStr = str(aRec[2])
        updateSQL = f"  UPDATE adressen SET orte_fk=(SELECT ort_id FROM orte WHERE name = '{ortStr:s}' AND plz = {plzStr:s}) WHERE ort='{ortStr:s}' AND plz={plzStr:s}"
        print(updateSQL)
        mycursor.execute(updateSQL)
    conn.commit()
else:
    print("This step is disabled!\n")

doVerifyData = True
print("\nVerifying data")
if doVerifyData:
    stm_verifyOrte = """
        SELECT
             `adressen`.`vorname`,
             `adressen`.`nachname`,
             `adressen`.`strasse`,
             `adressen`.`hausnummer`,
             `adressen`.`plz`,
             `adressen`.`ort`,
             `orte`.`plz`,
             `orte`.`name`
        FROM `adressen`
        JOIN `orte` ON `adressen`.`orte_fk` = `orte`.`ort_id`
        WHERE `adressen`.`plz` <> `orte`.`plz` or 
              `adressen`.`ort` <> `orte`.`name`;
    """
    mycursor.execute(stm_verifyOrte)
    myresult = mycursor.fetchall()
    if len(myresult) == 0:
       print("     all fine!!!!!!")

       print("\nRemove redundant columns")
       stm_removeRedundantData = """
            -- Redundante Felder (Attributte löschen)
            ALTER TABLE `adressen` 
                DROP COLUMN `ort`,
                DROP COLUMN `plz`;
       """
       print(stm_removeRedundantData)
       mycursor.execute(stm_removeRedundantData)
       conn.commit()

       print("\nSet FK to NOT NULL")
       stm_addNN_constraint = """
            -- After migration set FK to NOT NULL
            ALTER TABLE `adressen`
                 CHANGE COLUMN `orte_fk` `orte_fk` INT(10) UNSIGNED NOT NULL;
       """
       print(stm_addNN_constraint)
       mycursor.execute(stm_addNN_constraint)
       conn.commit()

       stm_joinAdressen = """
           SELECT
                `adressen`.`vorname`,
                `adressen`.`nachname`,
                `adressen`.`strasse`,
                `adressen`.`hausnummer`,
                `orte`.`plz`,
                `orte`.`name`
           FROM `adressen`
           JOIN `orte` ON `adressen`.`orte_fk` = `orte`.`ort_id`;
       """
       print(stm_joinAdressen)
       mycursor.execute(stm_joinAdressen)
       myresult = mycursor.fetchall()
       # print("Records found:", len(myresult), myresult)
       for aRec in myresult:
           print(aRec)
else:
    print("This step is disabled!\n")
