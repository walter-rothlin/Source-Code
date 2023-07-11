# Autor: Sean McGuinness
# Dieses Skript steht allen frei zur Verfuegung
# 2023

import mysql.connector

print("Mit [HIER DEN NAMEN DER DATENBANK EINFUEGEN] verbinden... ", end="", flush=True)
# Verbindungsaufbau zur MYSQL Datenbank
meine_db = mysql.connector.connect(
    host="localhost",
    user="HIER DEN DATENBANKBENUTZERNAMEN EINFUEGEN",
    password="HIER DAS PASSWORT EINFUEGEN",
    database="HIER DEN NAMEN DER DATENBANK EINFUEGEN",
    auth_plugin="mysql_native_password"
)
print("Erfolgreich verbunden")

tbl_choice = input("Tabellenname eingeben: ")
col_choice = input("Attribut zum Teilen eingeben: ")
sep_choice = input("Separator eingeben: ")
new_col_choice = input(f"Wo sollen Daten eingefügt werden? {col_choice} und: ")

# SELECT Statement um die benoetigten Daten aus der Tabelle zu ziehen
stm_select_tbl = f"SELECT {col_choice} FROM {tbl_choice};"
print(stm_select_tbl)

# Befehle durch mysql.connector an Datenbank senden und ausfuehren
mein_cursor = meine_db.cursor(dictionary=True)
mein_cursor.execute(stm_select_tbl)
mein_resultat = mein_cursor.fetchall()

# Liste wird mit den benoetigten Daten gefuellt
splitAddr = []

# Fuellt Liste mit Daten
for i in range(len(mein_resultat)):
    splitAddr += mein_resultat[i][col_choice].rsplit(" ", 1)

# Generiert UPDATE Statements für jeden Datensatz
n = 2
for x in range(len(mein_resultat)):

    if x == 0:
        stm_update = f"UPDATE {tbl_choice} SET {col_choice}= \
        \"{splitAddr[x]}\", {new_col_choice}=\"{splitAddr[x+1]}\" WHERE id={x+1};"

    else:
        stm_update = f"UPDATE {tbl_choice} SET {col_choice}= \
        \"{splitAddr[n]}\", {new_col_choice}=\"{splitAddr[n+1]}\" WHERE id={x+1};"
        n += 2
    print(f"Wird ausgeführt: {stm_update}")

    mein_cursor.execute(stm_update)

# Commitet die Aenderungen
meine_db.commit()
