sourceFileFN = "/Users/cedricauer/Desktop/210204_Testfile_01.txt"

# --------------------------------------------
#     Anzahl Zeilen auslesen, Versuch 3
# --------------------------------------------

file = open(sourceFileFN, "r")
line_count = 0
for line in file:
    if line != "\n":
        line_count += 1
file.close()

print(sourceFileFN, "enthält folgende Anzahl an Zeilen:", line_count)

# --------------------------------------------
#         Zeilen löschen, Versuch 3
# --------------------------------------------

# Anzahl Zeilen müssen ausgelesen werden,
# damit Python überhaupt weiss, wie viele Zeilen das File besitzt

# Datei öffnen (open) und lesen ("r")
# In diesem Fall sourceFileFN
# Gelesene Daten in Variable "a_file" ablegen
a_file = open(sourceFileFN, "r")

# Anzahl Zeilen mit dem File in Verbindung bringen
lines = a_file.readlines()

# Anzahl Zeilen speichern durch schliessen
a_file.close()

# Zeilen löschen:
# ACHTUNG: Zeilen-Nummerierung beginnt bei Null!
# Mit Doppelpunkt kann Anzahl Zeilen angegeben werden
# zb. 1 bis 5 = 0:5

del lines[0:20]

# Neues File ohne oben angegebene Zeilen schreiben

new_file = open(sourceFileFN, "w")
for line in lines:
    new_file.write(line)

new_file.close()


# Funktion Anzahl Zeilen auslesen gibt den Fehlercode zurück, dass bei file = open(sourceFileFN…) einen Einrückungsfehler bestehe? Weshalb ist das so?

def File_getCountOfLines(sourceFileFN):

    file = open(sourceFileFN, "r")
    line_count = 0
    for line in file:
        if line != "\n":
            line_count += 1
    file.close()

    return print(sourceFileFN, "enthält folgende Anzahl an Zeilen:", line_count)

File_getCountOfLines("/Users/cedricauer/Desktop/210204_Testfile_01.txt")

