#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: TI24BLf_Rothlin_Walter_MySQL.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_08_MySql/01_SelectSakila.py
#
# Description: Connects to sakila and queries data
#
# Autor: Walter Rothlin
#
# History:
# 17-Apr-2025   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
#
# Install driver first: python -m pip install mysql-connector-python
import mysql.connector  # mysql-connector-python not default mässiger one

def insert_ort(db, ort_name, country_id=1):
    # Create a cursor object
    ## sql = "INSERT INTO city (city, country_id) VALUES (%s, %s)"
    ## val = ("Ost-Uster", 1)
    ## my_cursor.execute(sql, val)
    ## my_cursor = db.cursor()

    sql = f"""
      INSERT INTO city (city, country_id) VALUES 
        ('{ortsname}', 1)"""

    print(sql)
    my_cursor.execute(sql)
    db_connection.commit()


# ================
# Haupt-Programm
# ================
print("Connecting to sakila....", end="", flush=True)
db_connection = mysql.connector.connect(
  host        = "localhost",
  user        = "TI24",
  password    = "TI24_007",
  database    = "sakila",
  auth_plugin = 'mysql_native_password'
)
print("completed!")

stm_selectCities = """
    SELECT * FROM address_city_country;

"""

stm_selectCities = """
    SELECT
       `city_id`    AS `ID`,
       `city`       AS `City`,
       `country_id` AS `Country`
    FROM 
       `city`
    WHERE 
       `city` like 'Os%'
"""







rs_as_dict = True
print(f"{stm_selectCities}\nResult-Set as Hash: {rs_as_dict}\n")

my_cursor = db_connection.cursor(dictionary=rs_as_dict)
my_cursor.execute(stm_selectCities)
my_results = my_cursor.fetchall()

print("Records found:", len(my_results))

ortsname= input('Ort:')
