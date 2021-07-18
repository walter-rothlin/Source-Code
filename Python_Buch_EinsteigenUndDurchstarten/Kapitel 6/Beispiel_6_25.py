# Beispiel 6.25
#
# Ersetzungen durchführen
#

# Einen Logbucheintrag erzeugen
log = "05.01.2018: Sind auf dem Planeten gelandet. Es gibt hier viel Leben."

print("Ursprünglicher Logbucheintrag:")
print(log)

# Eintrag etwas abändern
log = log.replace("viel", "leider kein")

# Datumsformat korrigieren
log = log.replace(".", "-", 2)

print("\nKorrigierter Logbucheintrag:")
print(log)
