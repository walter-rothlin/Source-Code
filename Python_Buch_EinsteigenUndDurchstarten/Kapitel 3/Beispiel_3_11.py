# Beispiel 3.11
#
# break und continue in for-Schleifen
#

endwert = int(input("Zähler abbrechen bei: "))
ignorieren = int(input("Zu ignorierende Zahl: "))

for i in range(11):
    if i == endwert:
        break

    if i == ignorieren:
        print("Zahl wird ignoriert")
        continue

    print("Zähler: ", i)

print("Zähler beendet")
