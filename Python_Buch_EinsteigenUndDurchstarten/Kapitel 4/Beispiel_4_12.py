# Beispiel 4.12
#
# Schlüsselwortparameter
#


# Einen neuen Wecker hinzufügen
def wecker_hinzufuegen(wochentag, stunde=7, minute=30, sekunde=0):
    print("Es wurde ein neuer Wecker hinzugefügt!")
    print("{0} um {1:02d}:{2:02d}:{3:02d}".format(wochentag, stunde,
                                                  minute, sekunde))
    print("------------------------------------------")


# Hauptprogramm
wecker_hinzufuegen("Samstag", 10)
wecker_hinzufuegen("Montag", 8, minute=45)
wecker_hinzufuegen("Dienstag", sekunde=50)
wecker_hinzufuegen("Mittwoch", sekunde=15, stunde=9)
