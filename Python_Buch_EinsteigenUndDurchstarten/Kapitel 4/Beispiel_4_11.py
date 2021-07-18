# Beispiel 4.11
#
# Standardwerte für Parameter
#


# Einen neuen Wecker hinzufügen
def wecker_hinzufuegen(wochentag, uhrzeit=7):
    print("Es wurde ein neuer Wecker hinzugefügt!")
    print(wochentag, "um", uhrzeit, "Uhr")
    print("------------------------------------------")


# Hauptprogramm
wecker_hinzufuegen("Samstag", 10)
wecker_hinzufuegen("Montag")
wecker_hinzufuegen("Dienstag")
