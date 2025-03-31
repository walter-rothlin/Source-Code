#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 01_SelectSakila.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_08_MySql/01_SelectSakila.py
#
# Description: Connects to sakila and queries data
#
# Autor: Walter Rothlin
#
# History:
# 26-May-2020   Walter Rothlin      Initial Version
# 11-Jun-2024   Walter Rothlin      Changes for BZU-A21
# ------------------------------------------------------------------
import mysql.connector

print("Connecting to pruefung....", end="", flush=True)
db_connection = mysql.connector.connect(
    host="localhost",
    user="root",
    password="admin",
    # database="pruefung_1",
    database="sakila",
    auth_plugin='mysql_native_password'
)
print("completed!")


sql_statement = """
SELECT
	`co`.`country`           AS `Land`,
    COUNT(`ci`.`country_id`)    AS `Anzahl Städte`
FROM `country` AS `co`
INNER JOIN `city` AS `ci` ON `co`.`country_id` = `ci`.`country_id`
GROUP BY `ci`.`country_id`
ORDER BY `Anzahl Städte` DESC;
"""

rs_as_dict = True
print(f"{sql_statement}\nResult-Set as Hash: {rs_as_dict}\n")

my_cursor = db_connection.cursor(dictionary=rs_as_dict)
my_cursor.execute(sql_statement)
my_results = my_cursor.fetchall()

print("Records found:", len(my_results))
if not my_results:
    print("No records found.")
    exit(0)

# Attribut-Namen aus der ersten Zeile extrahieren
first_tuple = my_results[0]
attr_names = first_tuple.keys()

# Berechnung der maximalen Breiten für jede Spalte
attr_value_lengths = {}
for a_tuple in my_results:
    for a_attr_name in attr_names:
        attr_value_lengths[a_attr_name] = max(
            attr_value_lengths.get(a_attr_name, len(a_attr_name)),
            len(str(a_tuple[a_attr_name]))
        )

# Erstellen von Header und Trennlinie
header = " | ".join(f"{a_attr_name:{attr_value_lengths[a_attr_name]}}" for a_attr_name in attr_names)
trennlinie = "-+-".join("-" * attr_value_lengths[a_attr_name] for a_attr_name in attr_names)

# Ausgabe der Tabelle
print(header)
print(trennlinie)

for a_tuple in my_results:
    row = " | ".join(f"{str(a_tuple[a_attr_name]):{attr_value_lengths[a_attr_name]}}" for a_attr_name in attr_names)
    print(row)





