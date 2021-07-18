# Beispiel 4.14
#
# Rekursion
#


# Rekursive Funktion für einen Countdown
def countdown(wert):
    print("Countdown:", wert)

    if wert > 0:
        countdown(wert-1)


# Hauptprogramm
countdown(10)
